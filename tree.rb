#estutura da arvore
   
 class AST  
    attr_writer :children,:tipo, :value, :nome
    attr_reader :children, :tipo, :value, :nome
    
    def initialize(nome)
        puts "inicia arvore"
        @nome = nome
        @@children = []
        @@children.push(@nome)
        @tipo = ""
        @value = 0
    end

    def seeChild()
        @@children.each do |child|
            puts child
        end
    end
    #defLEVELS fazer
end

class If < AST
    attr_reader :nome
    
    def initialize(exp, c_true, c_false)
        #puts "Criação do nó If"
        @@children.push(@nome = "IF")
        @@children.push(exp)
        @@children.push(c_true)
        @@children.push(c_false)
        @exp = exp
        @c_true = c_true
        @c_false = c_false
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

class Assign < AST
    attr_reader :nome
    def initialize(esq, op, dir)
        puts "Nó do tipo Assign"
        @nome = "Assign"
        @@children.push(esq)
        @@children.push(dir)
        @esq = esq
        @token = @op = op
        @right = right
    end
end

class While < AST
    attr_reader :nome

    def initialize(exp,commands)
        #puts "Nó do tipo While"
        @nome = "WHILE"
        @@children.push(@nome)
        @@children.push(exp)
        @@children.push(commands)
        @exp = exp
        @commands = commands
    end
end

class Read < AST
    def initialize(id)
        @nome = "READ"
        @children = []
    end
end





no = AST.new("MAIN")
no = If.new("a < b", "a++","b++")
no = While.new("d > 0","a = c + d")
#no.children.push(node.nome)
#no.children.push(node.children)
#node = If.new("c == d", "c++","d++")
#no.children.push(node.nome,node.children)
#no.seeChild
no.seeChild

