#estrutura da arvore
 class AST   
    attr_accessor :nome, :children, :tipo, :value,:root_node
    attr_reader :nome   
    
    def initialize(nome)
        self.nome = nome
        self.children = []
        self.tipo = nil
        self.value = nil
    end

    def treeLevel(level = 0)
        #definir nivel da arvore
    end
    
    def seeChild
        puts self.nome
        self.children.each do |child|
            puts child
        end
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

class Attr < AST
    attr_reader :nome
    def initialize(esq, op, dir)
        self.nome = "Assign"
        self.children.push(esq)
        self.children.push(dir)
        self.esq = esq
        self.token = self.op = op
        self.right = right
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
    attr_reader :id
    def initialize(id)
        super('Read')
        self.children.push(id)
        self.id = id
    end
end

class Print < AST
    def initialize(exp)
        self.children.push(exp)
        self.exp = exp
    end
end

class Expr < AST
    attr_reader :op
    def initialize(nome,op,left,right)
        super(nome)
        self.children.push(left)
        self.children.push(right)
        self.left
        self.op = op
        self.right = right
    end
end

class LogicalOp < Expr
    def initialize(op,left,right)   
        super('LogicalOp',op,left,right)      
    end
        def seeChild
            valor_esq = self.left.seeChild
            valor_dir = self.right.seeChild
            if self.op == "&&"
                if valor_esq == 0
                    return 0
                elsif valor_dir == 0
                    return 0
                else
                    return 1
                end
            elsif self.op == "||"
                if valor_esq != 0
                    return 1
                elsif valor_dir != 0
                    return 1 
                else
                    return 0
                end
            end
        end
end

class ArithOp < Expr
    def initialize(op,left,right)
        super('ArithOp',op,left,right)
    end

    def evaluate
        if !self.left?nil
            valor_esq = self.left.seeChild
        end
        if !self.right?nil
            valor_dir = self.right.seeChild
        end
        if self.op == "+"
            return valor_esq + valor_dir
        end
        if self.op == "-"
            return valor_esq - valor_dir
        end
        if self.op == "*"
            return valor_esq * valor_dir
        end
        if self.op == "/"
            return valor_esq / valor_dir
        end
    end
end

class RelOp < Expr
    def initialize(left,op,right)
        super('RelOp',op,left,right)
    end

    def evaluate
        a = self.children[0].evaluate
        b = self.children[1].__evaluate__()
        if(self.op == '<')
        	if(a.to_f < b.to_f)
        		c = True
        		return c
        	else
        		c = False
                return c
            end
        elsif(self.op == '<=')
        	if(a.to_f <= b.to_f)
        		c = True
        		return c
        	else
        		c = False
                return c
            end
        elsif(self.op == '>')
        	if(a.to_f > b.to_f)
        		c = True
        		return c
        	else
        		c = False
                return c
            end
        elsif(self.op == '>=')
        	if(a.to_f >= b.to_f)
        		c = True
        		return c
        	else
        		c = False
                return c
            end
        elsif(self.op == '==')
        	if(a.to_f == b.to_f)
        		c = True
        		return c
        	else
        		c = False
                return c
            end
        elsif(self.op == '!=')
        	if(a.to_f != b.to_f)
        		c = True
        		return c
        	else
        		c = False
                return c    
            end
        end
    end
end

class Id < AST
    attr_reader :token, :value

    def initialize(token)
        super('Id')
        self.token = token
        self.value = token.value
    end
end

class Num < AST
    def initialize(token)
        super('Num')
        self.token = token
        self.value = token.value
    end
       
    
    def seeChild
        return float(self.value)
    end
end
