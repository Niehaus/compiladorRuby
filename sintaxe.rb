require_relative 'analisador_lexico'
require_relative 'conjFirst'
require_relative 'tree'
include Teste
include ConjuntoFirst

module AnalisadorSintatico
  def construtor
    Teste::le_arquivo
    @token_entrada, @matriz = Teste::automato
   
   # puts 'Token          | Num. da Linha | Lexema'
    Dir.chdir("Resultados") 
    $asa = File.new("ASA.xml","w")
    $codPython = File.new("codPython.py","w")
    $anaSintax = File.new("AnaliseSintatica.txt","w")
    $anaSintax.write("------------Token Buffer----------------\nToken           | Num. da Linha | Lexema\n")
    @index = 0
    @tabela_simbolos = {}
    @tipo_variavel
    @tok_esperado
    @int_type = 0
    @float_type = 1
  end
  def saida
   $anaSintax.write("#{@matriz[@index][1]}".ljust(23) + "#{@matriz[@index][2]}".ljust(10) + "#{@matriz[@index][0]}\n")
  end

  def analise_sintatica()
    construtor
    programa() 
  end

  def programa()
    if @matriz[@index][1].to_s  == "INT"
      casa("INT")
      casa("MAIN")
      casa("LBRACKET")
      casa("RBRACKET")
      casa("LBRACE")
      node = AST.new("AST")
      ast = decl_comando(node)
      casa("RBRACE")
      node.seeChild(node.level) #gera ASA
      node.geraPython(node.level) #gera CodigoPython
      puts "Arquivos gerados: \n\tASA.xml \n\tcodPython.py\n\tAnaliseSintatica.txt \nPasta: Resultados"
    else
      retorna_erro
    end
    return ast # dentro ou fora?
  end

  def decl_comando(node)
    if @matriz[@index][1].to_s == "INT" or @matriz[@index][1].to_s == "FLOAT"
      node1 = declaracao(node)
      return decl_comando(node1)
    elsif @matriz[@index][1].to_s == "LBRACE" or @matriz[@index][1].to_s == "ID" or @matriz[@index][1].to_s == "IF" or
      @matriz[@index][1].to_s == "WHILE" or @matriz[@index][1].to_s == "READ" or @matriz[@index][1].to_s == "PRINT" or
      @matriz[@index][1].to_s == "FOR"
      node1 = comando(node)
      return decl_comando(node1)
    else
      return node
    end
  end

  def declaracao(node)
    if @matriz[@index][1].to_s == "INT" or @matriz[@index][1].to_s == "FLOAT"
      tipo() 
      hash_simbolos()
      id_node = Id.new(@tabela_simbolos[@matriz[@index][0]])##decidir como pegar esses valores
      casa("ID") 
      return decl2(node,id_node)#precisa conhecer no_id pra printar qd for decl+attr
    else
      retorna_erro('declaracao')
    end
    return node #retorna nó?
  end

  def decl2(node,id_node)
    if @matriz[@index][1].to_s == "COMMA"
      casa("COMMA")
      hash_simbolos()
      id_node = Id.new(@tabela_simbolos[@matriz[@index][0]])##decidir como pegar esses valores
      casa("ID")
      return decl2(node,id_node)
    elsif @matriz[@index][1].to_s == "PCOMMA"
      casa("PCOMMA")
      return node
    elsif @matriz[@index][1].to_s == "ATTR"
      casa("ATTR")
      expr_node = expressao()
      attr_node = Attr.new(id_node,"=",expr_node)
      node.children.push(attr_node)
      return decl2(node,id_node)#precisa conhecer no_id pra printar qd for decl+attr
    else
      retorna_erro('decl2')
    end
    return node
  end

  def tipo()
    if @matriz[@index][1].to_s == "INT"
      @tipo_variavel = "INT"
      casa("INT")
    elsif @matriz[@index][1].to_s == "FLOAT"
      @tipo_variavel = "FLOAT"
      casa("FLOAT")
    else
      retorna_erro('tipo')
    end
  end

  def comando(node)
    if @matriz[@index][1].to_s == "LBRACE"
     return bloco(node)
    elsif @matriz[@index][1].to_s == "ID"
      return atribuicao(node)
    elsif @matriz[@index][1].to_s == "IF"
      return comando_se(node)
    elsif @matriz[@index][1].to_s == "WHILE"
      return comando_enquanto(node)
    elsif @matriz[@index][1].to_s == "READ"
      return comando_read(node)
    elsif @matriz[@index][1].to_s == "PRINT"
      return comando_print(node)
    elsif @matriz[@index][1].to_s == "FOR"
      return comando_for(node)
    else
      retorna_erro('comando')
    end
  end

  def bloco(node)
    if @matriz[@index][1].to_s == "LBRACE"
      casa("LBRACE")
      block = DelimitadorBloco.new("Bloco")
      retorno = decl_comando(block)
      casa("RBRACE")
      node.children.push(retorno)
    else
      retorna_erro('bloco')
    end
    return node#fora ou dentro do if?
  end

  def atribuicao(node)
    if @matriz[@index][1].to_s == "ID"
      hash_simbolos()
      id_node = Id.new(@tabela_simbolos[@matriz[@index][0]])
      casa("ID")
      casa("ATTR")
      expr_node = expressao()
      node.children.push(Attr.new(id_node,"=",expr_node))
      casa("PCOMMA")
      return node
    else
      retorna_erro('atribuicao')
    end
    return node#fora ou dentro do if??
  end

  def comando_se(node)
    if @matriz[@index][1].to_s == "IF"
      if_node = If.new
      casa("IF") 
      casa("LBRACKET")
      expr_node = expressao()
      if_node.children.push(expr_node)
      casa("RBRACKET")
      c_true = DelimitadorBloco.new('c_true')
      retorno = comando(c_true)
      if_node.children.push(retorno)
      comando_senao(if_node)  
      node.children.push(if_node)
      return node
    else
      retorna_erro('comando_se')
    end
    return node#fora ou dentro do if?
  end

  def comando_senao(if_node)
    if @matriz[@index][1].to_s == "ELSE"
      c_false = DelimitadorBloco.new("c_false")
      casa("ELSE")
      retorno = comando(c_false)
      if_node.children.push(retorno)
      return if_node #claramente dentro do 'if'
    else
      return if_node
    end
  end

  def comando_enquanto(node)
    if @matriz[@index][1].to_s == "WHILE"
      while_node = While.new
      casa("WHILE")
      casa("LBRACKET")
      expr_node = expressao()
      while_node.children.push(expr_node)
      casa("RBRACKET")
      c_true = DelimitadorBloco.new("c_true")
      retorno = comando(c_true)
      while_node.children.push(retorno)
      node.children.push(while_node)
      return node
    else
      retorna_erro('comando_enquanto')
    end
    return node #dentro ou fora do if???
  end

  def comando_read(node)
    if @matriz[@index][1].to_s == "READ"
      read_node = Read.new
      casa("READ")
      expr_node =  expressao() #n sei se é isso mas deu certo
      read_node.children.push(expr_node)
      casa("ID")
      casa("PCOMMA")
      node.children.push(read_node)
      return node 
    else
      retorna_erro('comando_read')
    end
  end

  def comando_print(node)
    if @matriz[@index][1].to_s == "PRINT"
      print_node = Print.new
      casa("PRINT")
      casa("LBRACKET")
      expr_node =  expressao()
      print_node.children.push(expr_node)
      casa("RBRACKET")
      casa("PCOMMA")
      node.children.push(print_node)
      return node #dentro ou fora??
    else
      retorna_erro('comando_print')
    end
  end

  #pensar sobre
  def comando_for(node)
    if @matriz[@index][1].to_s == "FOR"
      for_node = For.new
      casa("FOR")
      casa("LBRACKET")
      atribuicao_for(for_node)
      casa("PCOMMA")
      expr_node = expressao()
      for_node.children.push(expr_node) 
      casa("PCOMMA")
      atribuicao_for(for_node)
      casa("RBRACKET")
      node1 = comando(for_node)
      node.children.push(node1)
    else
      retorna_erro('comando_for')
    end
      return node
  end

  def atribuicao_for(for_node)
    if @matriz[@index][1].to_s == "ID"
      hash_simbolos()
      id_node = Id.new(@tabela_simbolos[@matriz[@index][0]])
      casa("ID")
      casa("ATTR")
      expr_node = expressao()
      attr_node = Attr.new(id_node,"=",expr_node)
      for_node.children.push(attr_node)
    end
    return for_node
  end

  def expressao()
    if @matriz[@index][1].to_s == "ID" or @matriz[@index][1].to_s == "INTEGER_CONST" or @matriz[@index][1].to_s == "FLOAT_CONST" or @matriz[@index][1].to_s == "LBRACKET"
      expr = adicao()
      return relacao_opc(expr)
    else
      retorna_erro('expressao')
    end
  end

  def relacao_opc(expr)
    if @matriz[@index][1].to_s == "LT" 
      op_rel()
      expr2 = adicao()
      menor_node = RelOp.new(expr,"<",expr2)
      return relacao_opc(menor_node)
    elsif @matriz[@index][1].to_s == "LE"
      op_rel()
      expr2 = adicao()
      menorigual_node = RelOp.new(expr,"<=",expr2)
      return relacao_opc(menorigual_node)
    elsif @matriz[@index][1].to_s == "GT"
      op_rel()
      expr2 = adicao()
      maior_node = RelOp.new(expr,">",expr2)
      return relacao_opc(maior_node)
    elsif @matriz[@index][1].to_s == "GE"
      op_rel()
      expr2 = adicao()
      maiorigual_node = RelOp.new(expr,">=",expr2)
      return relacao_opc(maiorigual_node)
    else
      return expr
    end
  end

  def op_rel()
    if @matriz[@index][1].to_s == "LT"
      casa("LT")
    elsif @matriz[@index][1].to_s == "LE"
      casa("LE")
    elsif @matriz[@index][1].to_s == "GT"
      casa("GT")
    elsif @matriz[@index][1].to_s == "GE"
      casa("GE")
    else
      retorna_erro('op_rel')
    end
  end

  def adicao()
    if @matriz[@index][1].to_s == "ID" or @matriz[@index][1].to_s == "INTEGER_CONST" or @matriz[@index][1].to_s == "FLOAT_CONST" or @matriz[@index][1].to_s == "LBRACKET"
      expr = termo()
      adicao_opc(expr)
    else
      retorna_erro('adicao')
    end
  end

  def adicao_opc(expr)
    if @matriz[@index][1].to_s == "PLUS" 
      op_adicao()
      expr2 = termo()
      plus_node = ArithOp.new(expr,"+",expr2)
      return adicao_opc(plus_node)
    elsif  @matriz[@index][1].to_s == "MINUS"
      op_adicao()
      expr2 = termo()
      minus_node = ArithOp.new(expr,"-",expr2)
      return adicao_opc(minus_node)
    else
      return expr
    end
  end

  def op_adicao()
    if @matriz[@index][1].to_s == "PLUS"
      casa("PLUS")
    elsif @matriz[@index][1].to_s == "MINUS"
      casa("MINUS")
    else
      retorna_erro('op_adicao')
    end
  end

  def termo()
    if @matriz[@index][1].to_s == "ID" or @matriz[@index][1].to_s == "INTEGER_CONST" or @matriz[@index][1].to_s == "FLOAT_CONST" or @matriz[@index][1].to_s == "LBRACKET"
      expr = fator()
      return termo_opc(expr)
    else
      retorna_erro('termo')
    end
  end

  def termo_opc(expr)
    if @matriz[@index][1].to_s == "MULT" 
      op_mult()
      expr2 = fator()
      mult_node = ArithOp.new(expr,"*",expr2)
      return termo_opc(mult_node)
    elsif @matriz[@index][1].to_s == "DIV"
      op_mult()
      expr2 = fator()
      div_node = ArithOp.new(expr,"/",expr2)
      return termo_opc(div_node)
    else
      return expr
    end
  end

  def op_mult()
    if @matriz[@index][1].to_s == "MULT"
      casa("MULT")
    elsif @matriz[@index][1].to_s == "DIV"
      casa("DIV")
    else
      retorna_erro('op_mult')
    end
  end

  def fator()
    if @matriz[@index][1].to_s == "ID"
      hash_simbolos()
      id_node = Id.new(@tabela_simbolos[@matriz[@index][0]])##decidir como pegar esses valores
      casa("ID")
      return id_node
    elsif @matriz[@index][1].to_s == "INTEGER_CONST"
      num_node = Num.new(@matriz[@index][0].join,@int_type)
      casa("INTEGER_CONST")
      return num_node
    elsif @matriz[@index][1].to_s == "FLOAT_CONST"
      num_node = Num.new(@matriz[@index][0].join,@float_type)
      casa("FLOAT_CONST")
      return num_node
    elsif @matriz[@index][1].to_s == "LBRACKET"
      casa("LBRACKET")
      expr = expressao()
      casa("RBRACKET")
      return expr
    else
      retorna_erro('fator')
    end
  end

  def casa(token_esperado)
    @tok_esperado = token_esperado
    if @matriz[@index][1].to_s == token_esperado.to_s
      if @index < @matriz.length
        saida
        @index += 1
        return @matriz[@index]
      else
        exit!
      end
    else
      casa_erro(token_esperado)
    end
  end

  def retorna_erro(terminal)
    puts "ERRO: valor #{ConjuntoFirst::MY_HASH[terminal]} não encontrado na linha #{@matriz[@index - 1][2]}"
  end

  def casa_erro(tokenES)
    puts "ERRO: valor #{tokenES} não encontrado na linha #{@matriz[@index][2]}"
  end

  def hash_simbolos()
    if !@tabela_simbolos[@matriz[@index][0]]
      @tabela_simbolos[@matriz[@index][0]] = [@matriz[@index][0], @matriz[@index][2], @tipo_variavel]
    end
    return @tabela_simbolos
  end

end

include AnalisadorSintatico
analise_sintatica()
