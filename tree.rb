#estrutura da arvore
 class AST   
    attr_accessor :nome, :children, :tipo, :value,:root_node,:level   

    def initialize(nome)
        self.nome = nome
        self.children = []
        self.tipo = nil
        self.value = nil
        self.level = 0
    end

    def seeChild(level)
        if self.nome == 'RelOp' or self.nome == "ArithOp"
            puts "   " *(0 + level) +"<#{self.nome} op='#{self.op}'>"
        elsif self.nome == "c_true" or self.nome  == "c_false"
            #não printa nda pra isso n aparecer
        elsif self.nome  == "Num"
            puts "   " *(0 + level) +"<#{self.nome} value= #{self.value} type='#{self.tipo}'/>"
        elsif self.nome == "Id"
            puts "   " *(0 + level) +"<#{self.nome} lexema='#{self.lexema}' type='#{self.tipo}'/>"
        else
            puts "   " *(0 + level) +"<#{self.nome}>"
        end
        self.children.each do |child|
            if child.class != String && child.class != NilClass
                child.seeChild(level + 1)
            else 
                puts "      " *(0 + level) + "#{child}"
            end
        end
        if self.nome == "c_true" or self.nome  == "c_false"
            #não printa nda pra isso n aparecer
        elsif self.nome == "Id" or self.nome  == "Num"
           #não printa nada pra isso n aparecer 
        else
            puts "   " *(0 + level) +"</#{self.nome}>"
        end 
    end

end

class Attr < AST #talvez altere
    attr_writer :esq, :op, :token, :dir
    attr_reader :nome, :esq, :op, :token, :dir
    def initialize(esq, op, dir)
        super("Attr")
        self.children.push(esq)
        self.children.push(dir)
        self.esq = esq
        self.token = self.op = op
        self.dir = dir
    end
end

class If < AST
    def initialize
        super("If")
    end
end

class While < AST
    def initialize
        super('While')
    end
end

class For < AST
    def initialize
        super('For')
    end
end

class Read < AST
    def initialize(id)
        super('Read')
    end
end

class Print < AST
    def initialize
        super("Print")
    end
end

class Expr < AST
    attr_reader :op
    def initialize(nome,op,left,right)
        super(nome)
        self.op = op
        self.children.push(left)
        self.children.push(right)
    end
end

class LogicalOp < Expr
    attr_accessor :op,:left,:right
    def initialize(op,left,right)   
        super('LogicalOp',op,left,right)      
    end
end

class ArithOp < Expr
    attr_accessor :left, :op, :right
    def initialize(left,op,right)
        super('ArithOp',op,left,right)
    end
end

class RelOp < Expr
    attr_accessor :left,:op,:right
    def initialize(left,op,right)
        super('RelOp',op,left,right)
    end
end

class Id < AST ##precisa rever
    attr_reader :lexema
    attr_accessor :lexema
    def initialize(lexema)
        super('Id')
        self.lexema = lexema[0]
        if lexema[2] == 'INT'
            self.tipo = "Integer"
        else
            self.tipo = "Float"
        end
    end
end

class Num < AST #precisa rever também
    attr_accessor :lexema, :tipo

    def initialize(lexema,tipo)
        super('Num')
        self.lexema = lexema
        if tipo == 0
          self.value = self.lexema.to_i
          self.tipo = 'Integer'
        else
           self.value = self.lexema.to_f
          self.tipo = 'Float'
        end
    end       
end

class DelimitadorBloco < AST
    def initialize
        super("Bloco")
    end
end
#node = If.new("exp","ctrue",If.new("exp2","ctrue2","cfalse2"))
#root_node = AST.new("Main")
#attr_node = Attr.new("esq","op","dir")
#if_node = If.new("exp","c_true",attr_node)
#while_node = While.new("exp","commands")

#root_node.children << if_node
#root_node.children << while_node
#puts "-" * 15
#puts "| Arvore - ASA |"
#puts "-" * 15
#root_node.seeChild(root_node.level)
