#estrutura da arvore
 class AST   
    attr_accessor :nome, :children, :tipo, :value,:root_node,:level
    attr_reader :nome,:level   
    
    def initialize(nome)
        self.nome = nome
        self.children = []
        self.tipo = nil
        self.value = nil
        self.level = 0
    end

    def treeLevel(level = 0)
        #definir nivel da arvore
    end
    
    def seeChild(level)
        puts "  " *(0 + level) +"<#{self.nome}>"
        self.children.each do |child|
            if child.class != String
                child.seeChild(level + 1)
            else 
                puts "  " *(1 + level) + "#{child}"
            end
        end
         puts "  " *(0 + level) +"</#{self.nome}>" 
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
end

class If < AST
    
    attr_writer :exp, :c_false, :c_true
    attr_reader :exp, :c_false, :c_true
    
    def initialize(exp, c_true, c_false)
        super("If")
        self.children.push(exp)
        self.children.push(c_true)
        self.children.push(c_false)
        self.exp = exp
        self.c_true = c_true
        self.c_false = c_false
    end

end

class DelimitadorBloco < AST
    attr_reader :nome
    def initialize
        puts "Criando delimitador de Bloco"
        @nome = "Block"
       # @children = []
    end
end

class While < AST
    attr_reader  :exp, :commands
    attr_writer  :exp, :commands

    def initialize(exp,commands)
        super('While')
        self.children.push(exp)
        self.children.push(commands)
        self.exp = exp
        self.commands = commands
    end
end

class Read < AST
    attr_reader :id,:nome
    def initialize(id)
        super('Read')
        self.children.push(id)
        self.id = id
    end
end

class Print < AST
    attr_reader :nome
    def initialize(exp)
        super("Print")
        self.children.push(exp)
        self.exp = exp
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
    def initialize(op,left,right)   
        super('LogicalOp',op,left,right)      
    end
    
end

class ArithOp < Expr
    def initialize(op,left,right)
        super('ArithOp',op,left,right)
    end
end

class RelOp < Expr
    def initialize(left,op,right)
        super('RelOp',op,left,right)
    end
end

class Id < AST
    attr_reader :token, :value

    def initialize(token)
        super('Id')
        self.token = token
        self.value = token.value ##pegar tal token da tabela de simbolos(mudar)
    end
end

class Num < AST
    def initialize(token,tipo)
        super('Num')
        self.token = token
        if tipo == 0
            self.value = token.lexema.to_i
        else
            self.value = token.lexema.to_f
        end
        self.tipo = tipo
    end
       
end


#node = If.new("exp","ctrue",If.new("exp2","ctrue2","cfalse2"))
root_node = AST.new("Main")
attr_node = Attr.new("esq","op","dir")
if_node = If.new("exp","c_true",attr_node)
while_node = While.new("exp","commands")

root_node.children << if_node
root_node.children << while_node
root_node.seeChild(root_node.level)
