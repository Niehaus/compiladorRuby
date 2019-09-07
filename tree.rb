require 'fileutils'
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

     def espacamento(level)
        deslocamento = "";
        while(level != 0)
            level = level - 1
            deslocamento << "    "
        end
        return deslocamento
    end

    def seeChild(level)
        if self.nome == 'RelOp' or self.nome == "ArithOp"
            $asa.write(espacamento(level) +"<#{self.nome} op='#{self.op}'>\n")
        elsif self.nome == "c_true" or self.nome  == "c_false"
            #não printa nda pra isso n aparecer
        elsif self.nome  == "Num"
           $asa.write(espacamento(level) +"<#{self.nome} value= #{self.value} type='#{self.tipo}'/>\n")
        elsif self.nome == "Id"
            $asa.write(espacamento(level) +"<#{self.nome} lexema='#{self.lexema}' type='#{self.tipo}'/>\n")
        else
            $asa.write(espacamento(level) +"<#{self.nome}>\n")
        end
        self.children.each do |child|
            if child.class != String && child.class != NilClass
                child.seeChild(level + 1)
            else 
                $asa.write(espacamento(level) + "#{child}")
            end
        end
        if self.nome == "c_true" or self.nome  == "c_false"
            #não printa nda pra isso n aparecer
        elsif self.nome == "Id" or self.nome  == "Num"
           #não printa nada pra isso n aparecer 
        else
            $asa.write(espacamento(level) +"</#{self.nome}>\n")
        end 
    end   

    def geraPython(level)
        self.children.each do |child|
            $codPython.write(child.geraPython(level).to_s)
        end
    end

    

end

class Attr < AST
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

    def geraPython(level)
        return espacamento(level) + self.children[0].geraPython(level) + " " + self.op + " " + self.children[1].geraPython(level) + "\n"    
    end
end

class If < AST
    def initialize
        super("If")
    end

    def geraPython(level)
        if self.children[2].class == NilClass
            return espacamento(level) + "if " + self.children[0].geraPython(level) + ":\n" + self.children[1].geraPython(level + 1)
        elsif self.children[2].children[0].nome == "If"
            if self.children[2].children[0].children[2].class != NilClass
                return espacamento(level) + "if " + self.children[0].geraPython(level) + ":\n" + self.children[1].geraPython(level + 1) + 
                espacamento(level) + "elif " + self.children[2].children[0].children[0].geraPython(level) + ":\n" + self.children[2].children[0].children[1].geraPython(level + 1) + espacamento(level) + "else:\n" + self.children[2].children[0].children[2].geraPython(level + 1)
            else
                return espacamento(level) + "if " + self.children[0].geraPython(level) + ":\n" + self.children[1].geraPython(level + 1) + 
                espacamento(level) + "elif " + self.children[2].children[0].children[0].geraPython(level) + ":\n" + self.children[2].children[0].children[1].geraPython(level + 1)    
            end
            return espacamento(level) + "if " + self.children[0].geraPython(level) + ":\n" + self.children[1].geraPython(level + 1) + espacamento(level) + "el" + self.children[2].children[0].geraPython(level - 1)                
        else
            return espacamento(level) + "if " + self.children[0].geraPython(level) + ":\n" + self.children[1].geraPython(level + 1) + espacamento(level) + "else:\n" + self.children[2].geraPython(level + 1)                
        end
    end

end

class While < AST
    def initialize
        super('While')
    end

    def geraPython(level)
        return espacamento(level) + "while " + self.children[0].geraPython(level) + ":\n" + self.children[1].geraPython(level + 1)
    end
end

class For < AST
    def initialize
        super('For')
    end

     def geraPython(level)
        if level == 0
            return self.children[0].geraPython(level) + espacamento(level) + "while " + self.children[1].geraPython(level) + ":\n" + self.children[3].geraPython(level + 1) + "    " + self.children[2].geraPython(level)
        else
            return self.children[0].geraPython(level) + espacamento(level) + "while " + self.children[1].geraPython(level) + ":\n" + self.children[3].geraPython(level + 1) + espacamento(level) + self.children[2].geraPython(level)
        end
    end
end

class Read < AST
    def initialize
        super('Read')
    end

    def geraPython(level)
        return espacamento(level) + "read(#{self.children[0].tipo}(#{self.children[0].geraPython(level)}))" + "\n"      
    end
end

class Print < AST
    def initialize
        super("Print")
    end
    
    def geraPython(level)
        return espacamento(level) + "print(\"Valor da variável " + "\" + " + "str(" + self.children[0].geraPython(level) +"))" + "\n"          
    end
end

class Expr < AST
    attr_reader :op
    def initialize(nome,op,left,right,parenteses)
        super(nome)
        self.op = op
        self.children.push(left)
        self.children.push(right)
        if parenteses == 1
            self.parenteses = 1
        else
            self.parenteses = 0
        end
    end

    def geraPython(level)
        if self.parenteses == 1
            return "(" + self.children[0].geraPython(level) + " " + self.op + " " + self.children[1].geraPython(level) + ")"
        else
            return self.children[0].geraPython(level) + " " + self.op + " " + self.children[1].geraPython(level) 
        end

        
    end
end


class ArithOp < Expr
    attr_accessor :left, :op, :right, :parenteses
    def initialize(left,op,right,parenteses)
        super('ArithOp',op,left,right,parenteses)
    end

     
end

class RelOp < Expr
    attr_accessor :left,:op,:right,:parenteses
    def initialize(left,op,right,parenteses)
        super('RelOp',op,left,right,parenteses)
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
    
    def geraPython(level)
        return self.lexema
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
    
    def geraPython(level)
        return self.value.to_s
    end
end

class DelimitadorBloco < AST
    def initialize(nome)
        super(nome)
    end

    def geraPython(level)
        code = ""
        self.children.each do |child|
            code << child.geraPython(level).to_s    
                    
        end   
        return code
    end
    
end 
