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

    def seeChild(level)
        
        if self.nome == 'RelOp' or self.nome == "ArithOp"
            $asa.write("   " *(0 + level) +"<#{self.nome} op='#{self.op}'>\n")
        elsif self.nome == "c_true" or self.nome  == "c_false"
            #não printa nda pra isso n aparecer
        elsif self.nome  == "Num"
           $asa.write("   " *(0 + level) +"<#{self.nome} value= #{self.value} type='#{self.tipo}'/>\n")
        elsif self.nome == "Id"
            $asa.write("   " *(0 + level) +"<#{self.nome} lexema='#{self.lexema}' type='#{self.tipo}'/>\n")
        else
            $asa.write("   " *(0 + level) +"<#{self.nome}>\n")
        end
        self.children.each do |child|
            if child.class != String && child.class != NilClass
                child.seeChild(level + 1)
            else 
                $asa.write("      " *(0 + level) + "#{child}")
            end
        end
        if self.nome == "c_true" or self.nome  == "c_false"
            #não printa nda pra isso n aparecer
        elsif self.nome == "Id" or self.nome  == "Num"
           #não printa nada pra isso n aparecer 
        else
            $asa.write("   " *(0 + level) +"</#{self.nome}>\n")
        end 
    end   

    def geraPython(level)
        self.children.each do |child|
            $codPython.write(child.geraPython(level).to_s + "\n")
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
    def geraPython(level)
         return " " *(0 + level)+ self.children[0].geraPython(level) + " " + self.op + " " +self.children[1].geraPython(level)
    end
end

class If < AST
    def initialize
        super("If")
    end
    def geraPython(level) #achar expressão, achar caminho true, verificar se existe c_false e aí return em tdo
        if self.children[2].class == NilClass
            return  " " *(0 + level) +"if "  + self.children[0].geraPython(level) + ":"+ "\n" + self.children[1].geraPython(level) + "\n"
        else
            if self.children[2].children[0].nome == "If"
                return  " " *(0 + level) +"if "  + self.children[0].geraPython(level) + ":\n" + self.children[1].geraPython(level) + "\n" + " " *(0 + level) + "el" + self.children[2].children[0].geraPython(level)
            else
                return  " " *(0 + level) +"if " + self.children[0].geraPython(level) + ":\n" + self.children[1].geraPython(level) + "\n" +  " "*(0 + level) + "else:\n" + self.children[2].geraPython(level)  
            end
        end  
    end
end

class While < AST
    def initialize
        super('While')
    end

    def geraPython(level)
        return "while " + self.children[0].geraPython(level) + ":\n" + self.children[1].geraPython(level)
    end
end

class For < AST
    def initialize
        super('For')
    end

     def geraPython(level)
        return self.children[0].geraPython(level) + "\nwhile " + self.children[1].geraPython(level) + ":\n" + self.children[3].geraPython(level) + "\n"+ " #{self.children[2].geraPython(level)}"
    end
end

class Read < AST
    def initialize
        super('Read')
    end

    def geraPython(level)
        return "read(#{self.children[0].tipo}(#{self.children[0].geraPython(level)}))"        
    end
end

class Print < AST
    def initialize
        super("Print")
    end
    
    def geraPython(level)
        return "print(""Valor da variável a:"" + str(#{self.children[0].geraPython(level)}))"          
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

    def geraPython(level)
        return "#{self.children[0].geraPython(level)} #{self.op} #{self.children[1].geraPython(level)}"
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
        code = "";
        self.children.each do |child|
            code << " " *(0 + level)
            code << child.geraPython(level + 1).to_s
        end  
        return code
    end
    
end 
