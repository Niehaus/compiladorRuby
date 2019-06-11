#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Aug 26 10:28:28 2017

@author: alexandre
"""
#TOKEN CODES
EOF = -1
ID = 0
INTEGER_CONST = 1
FLOAT_CONST = 2
LBRACKET = 3
RBRACKET = 4
PLUS = 5
MINUS = 6
MULT = 7
DIV = 8
INT = 9
FLOAT = 10
MAIN = 11
LBRACE = 12
RBRACE = 13
COMMA = 14
PCOMMA = 15
ATTR = 16
IF = 17
ELSE = 18
WHILE = 19
PRINT = 20
READ = 21
OR = 22
AND = 23
EQ = 24
NE = 25
LT = 26
LE = 27
GT = 28
GE = 29
FOR = 30

int_type = 0
float_type = 1

typeNames = {}
typeNames[int_type] = 'int'
typeNames[float_type] = 'float'

class Token(object):
    def __init__(self, type, value):
        self.type = type
        self.lexema = value
        self.numLinha = None
        self.value = None

    def __str__(self):
        """String representation of the class instance.

        Examples:
            Token(INTEGER_CONST, 3)
            Token(PLUS, '+')
            Token(MUL, '*')
        """
        return 'Token({type}, {lexema})'.format(
            type= tokenNames[self.type],
            lexema=self.lexema
        )

    def __repr__(self):
        return str(self.type)

    def __convertTo__(self):
        return

"""
 A tabela de símbolos é implementada como uma classe com o seguinte campo:
     - Map<string,TableEntry> symbolTable; //Um mapa de objetos tableEntry
"""
"""
 TableEntry é uma classe que possui os seguintes campos:
     - lexema
     - tipo
     - ponteiro para o valor
     - num da linha
"""
class SymbolTable(object):
    def __init__(self):
        self.symbolTable = {}

    def insertEntry(self, lexema, entry):
        self.symbolTable[lexema] = entry;

    def getEntry(self, lexema):
        if (self.symbolTable[lexema]):
            return self.symbolTable[lexema]
        else:
            return None

    def __repr__(self):
        str_res = ''
        for i in self.symbolTable:
            str_res += ('{' + str(i) + ',' + str(self.symbolTable[i]) + '}') + '\n'
        return str_res

class TableEntry(object):
    def __init__(self, lexema, tipo, num_linha, ref_valor):
        self.lexema = lexema
        self.tipo = tipo
        self.num_linha = num_linha
        self.ref_valor = ref_valor

    def setTipo(self, tipo):
        self.tipo = tipo

    def setRefValor(self, rv):
        self.ref_valor = rv

    def __repr__(self):
        if self.tipo == 0:
            nometipo = "int"
        else:
            nometipo = "float"
        if (self.ref_valor == None):
            valor = "NULL"
        return '<lexema: ' + str(self.lexema) + ', tipo: ' + nometipo + ', valor: ' + valor + '>'

"""
    Classes da árvore de sintaxe abstrata (também chamada AST ou ASA)
"""
class Astnode(object):
    def __init__(self, nome):
         self.nome = nome;
         self.children = []
         self.tipo = None
         self.value = None

    #Método que imprime um nó
    def __str__(self, level=0):
        ret = "   "*level+ repr(self) +"\n"
        for child in self.children:
            if (child != None):
                ret += child.__str__(level+1) #level+1
        return ret

    def __repr__(self):
        return self.nome

class Attr(Astnode):
    def __init__(self):
        Astnode.__init__(self,'Attr');
        print('Criando um nó do tipo Attr.')

    def __repr__(self):
        return self.nome

class If(Astnode):

    def __init__(self):
        Astnode.__init__(self, 'If')
        print('Criando um nó do tipo If.')

    def __repr__(self):
        return self.nome

class While(Astnode):
    def __init__(self):
        Astnode.__init__(self,'While')
        print('Criando um nó do tipo While.')

    def __repr__(self):
        return self.nome

class Read(Astnode):
    def __init__(self, id_):
        Astnode.__init__(self,'Read')
        print('Criando um nó do tipo Read.')
        self.children.append(id_)

    def __repr__(self):
        return self.nome

class Print(Astnode):
    def __init__(self, exp):
        Astnode.__init__(self,'Print')
        print('Criando um nó do tipo Print.')
        self.children.append(exp)

    def __repr__(self):
        return self.nome

class Expr(Astnode):
    def __init__(self, nome, op, left, right):
        Astnode.__init__(self,nome)
        self.op = op
        self.children.append(left)
        self.children.append(right)

    def __repr__(self):
        return self.op  # + ': ' + self.children[0].__repr__() + ', ' + self.children[1].__repr__()

class LogicalOp(Expr):
    def __init__(self, op, left, right):
        Expr.__init__(self,'LogicalOp', op, left, right)
        print('Criando um nó do tipo LogicalOp com operador ' + str(op))

class ArithOp(Expr):
    def __init__(self, op, left, right):
        Expr.__init__(self,'ArithOp', op, left, right)
        print('Criando um nó do tipo ArithOp com operador ' + str(op))

class RelOp(Expr):
    def __init__(self, left, op, right):
        Expr.__init__(self,'RelOp', op, left, right)
        print('Criando um nó do tipo RelOp com operador ' + str(op))

class Id(Astnode):
    def __init__(self, entradaTabSimbolos):
        Astnode.__init__(self,'Id')
        print('Criando um nó do tipo Id.')
        self.entradaTabSimbolos = entradaTabSimbolos

    def __repr__(self):
        return 'ID: ' + repr(self.entradaTabSimbolos)

    # def __str__(self):
    #     return str(self.entradaTabSimbolos.lexema)

class Num(Astnode):
    def __init__(self, token, type_):
        Astnode.__init__(self,'Num')
        print('Criando um nó do tipo Num.')
        self.token = token
        if (type_ == 0):
            self.value = int(token.lexema)  #em python, não precisamos nos preocupar com o tipo de value
        else:
            self.value = float(token.lexema)
        self.type = type_;

    def __repr__(self):
        if (self.type == 0):
            string = "{INTEGER_CONST, valor:" + str(self.value) +"}"
        else:
            string = "{FLOAT_CONST, valor:" + str(self.value) +"}"
        return string

    def __evaluate__(self):
        return self.value

tokenNames = {}
tokenNames[EOF] = 'EOF';
tokenNames[ID] = 'ID'
tokenNames[INTEGER_CONST] = 'INTEGER_CONST'
tokenNames[FLOAT_CONST] = 'FLOAT_CONST'
tokenNames[LBRACKET] = 'LBRACKET'
tokenNames[RBRACKET] = 'RBRACKET'
tokenNames[PLUS] = 'PLUS'
tokenNames[MINUS] = 'MINUS'
tokenNames[MULT] = 'MULT'
tokenNames[DIV] = 'DIV'

tk1 = Token(ID, 'a')
tkplus = Token(PLUS, '+')
tkint1 = Token(INTEGER_CONST, 5)
tkdiv = Token(DIV, '/')
tk6 = Token(ID, 'b')
tkeof = Token(EOF, 'EOF')
tklbracket = Token(LBRACKET, '(')
tkrbracket = Token(RBRACKET, ')')
tkminus = Token(MINUS, '-')
tkmult = Token(MULT, '*')

tkfloat1 = Token(FLOAT_CONST, 3.5)
tkfloat2 = Token(FLOAT_CONST, 1.22)
tkint2 = Token(INTEGER_CONST, 2)
tkintconst4 = Token(INTEGER_CONST, 4)

tkinttype = Token(INT, 'int')
tkfloattype = Token(FLOAT, 'float')
tklbrace = Token(LBRACE, '{')
tkrbrace = Token(RBRACE, '}')
tkmain = Token(MAIN, 'main')
tkpcomma = Token(PCOMMA,';')
tkcomma = Token(COMMA,',')
tkif = Token(IF,'if')
tklt = Token(LT,'<')
tkle = Token(LE,'<=')
tkgt = Token(GT,'>')
tkge = Token(GE,'>=')

#vetorTokens = [tkinttype, tkmain, tklbracket, tkrbracket,
#                tklbrace, tkinttype, Token(ID, 'i'), Token(ATTR, '='), Token(INTEGER_CONST, 0),
#                tkpcomma, Token(ID, 'i'), Token(ATTR, '='), Token(ID, 'i'),
#                tkplus, tkint2, tkmult, tkintconst4, tkpcomma, tkrbrace, tkeof]

# vetorTokens = [tkinttype, tkmain, tklbracket, tkrbracket,
#             tklbrace,
#                tkinttype, Token(ID, 'j'), tkpcomma,
#                tkinttype, Token(ID, 'i'), Token(ATTR, '='), Token(INTEGER_CONST, 10), tkpcomma,
#                tkfloattype, Token(ID, 'a'), Token(ATTR, '='), Token(FLOAT_CONST, 1.5), tkminus, Token(FLOAT_CONST, 2.5), tkpcomma,
#                 Token(ID, 'i'), Token(ATTR, '='), Token(ID, 'i'), tkplus, Token(ID, 'a'),tkplus, tkint2, tkmult, tkintconst4, tkpcomma,
#                 tkfloattype, Token(ID, 'b'), tkpcomma,
#                 Token(ID, 'j'), Token(ATTR, '='), Token(ID, 'i'), tkpcomma,
#                 tkif, tklbracket, Token(ID, 'a'), tkle, Token(ID, 'b'), tkrbracket,
#                 tkif, tklbracket, Token(ID, 'i'), tkgt, Token(INTEGER_CONST, 0), tkrbracket,
#                 tklbrace,
#                 Token(ID, 'a'), Token(ATTR,'='), Token(INTEGER_CONST, 260), tkpcomma,
#                 Token(ID, 'b'), Token(ATTR,'='), Token(FLOAT_CONST, -58.7), tkpcomma,
#                 tkrbrace,
#             tkrbrace, tkeof]

# tkattr = Token(ATTR,'=')
# vetorTokens = [tkinttype, tkmain, tklbracket, tkrbracket,
#         tklbrace,
#         tkinttype, Token(ID, 'j'), tkattr, Token(INTEGER_CONST, 2),
# 		tkcomma, Token(ID, 'i'), tkattr, Token(INTEGER_CONST, 4), tkpcomma,
#         Token(ID, 'i'), tkattr, Token(INTEGER_CONST, 10),tkpcomma,
# 		tkrbrace,
#         tkeof]

vetorTokens = [tkinttype, tkmain, tklbracket, tkrbracket,
    tklbrace,
    tkinttype, Token(ID, 'j'), tkpcomma,
    tkinttype, Token(ID, 'i'), Token(ATTR, '='), Token(INTEGER_CONST, 10), tkpcomma,
    tkfloattype, Token(ID, 'a'), Token(ATTR, '='), Token(FLOAT_CONST, 1.5), tkminus, Token(FLOAT_CONST, 2.5), tkpcomma,
    Token(ID, 'i'), Token(ATTR, '='), Token(ID, 'i'), tkplus, Token(ID, 'a'),tkplus,
    tkint2, tkmult, tkintconst4, tkpcomma,
    tkfloattype, Token(ID, 'b'), tkpcomma,
    Token(ID, 'j'), Token(ATTR, '='), Token(ID, 'i'), tkpcomma,
    tkif, tklbracket, Token(ID, 'a'), tkplus, Token(ID, 'b'), tkrbracket,
        tkif, tklbracket, Token(ID, 'i'), tkmult, Token(INTEGER_CONST, 0), tkrbracket,
            Token(ID, 'b'), Token(ATTR,'='), Token(FLOAT_CONST, -58.7), tkpcomma,
            Token(ELSE,'else'),
             Token(ID, 'b'), Token(ATTR,'='), Token(FLOAT_CONST, 345.345), tkpcomma,

    tkrbrace, tkeof]


i = 0;
token = vetorTokens[i];

currentType = None
currentTableEntry = None
currentToken = None

tabSimbolos = SymbolTable()

def match(tok):
    global token, i;
    if(token.type == tok):
        #print('Token ' + repr(token) + ' reconhecido na entrada.')
        i = i + 1
        if (i < len(vetorTokens)):
            token = vetorTokens[i]
    else:
        print('Erro sintático. Token ' + repr(token) + ' não esperado na entrada.')
        return ;
        #i = i + 1
        #token = vetorTokens[i]
        #sincroniza(tok)

def Programa():
    global token, tabSimbolos, currentType, currentTableEntry, currentToken;
    match(INT);
    match(MAIN);
    match(LBRACKET);
    match(RBRACKET);
    match(LBRACE);
    lista = Astnode('Main') #Cria o nó raiz da AST
    ast = Decl_Comando(lista);
    match(RBRACE);
    if(token.type == EOF):
        match(EOF)
        print('Fim da análise sintática.\n')
    return ast

def Decl_Comando(no):
    print('Decl_Comando recebeu:\n ' + str(no))
    global token, tabSimbolos, currentType, currentTableEntry, currentToken;
    if (token.type == INT or token.type == FLOAT):
        no = Declaracao(no);
        print('Declaracao retornou:\n ' + str(no))
        return Decl_Comando(no);
    elif (token.type == ID or token.type == IF or token.type == WHILE or token.type == PRINT
          or token.type == READ or token.type == FOR):
        no = Comando(no); #Criamos nós na ast para cada comando encontrado
        print('Comando retornou:\n ' + str(no))
        return Decl_Comando(no);
    return no

def Declaracao(no):
    global token, tabSimbolos, currentType, currentTableEntry, currentToken;
    Tipo();
    if (token.type == ID):
        #cria uma entrada na tabela de símbolos para esse identificador
        currentToken = token
        te = TableEntry(token.lexema, currentType, None, None)
        currentTableEntry = te
        tabSimbolos.insertEntry(token.lexema, te)
        match(ID);
        return Decl2(no);
    return no;

def Tipo():
    global token, tabSimbolos, currentType, currentTableEntry, currentToken;
    if (token.type == INT):
        match(INT);
        currentType = int_type
    elif (token.type == FLOAT):
        match(FLOAT);
        currentType = float_type

def Decl2(no):
    global token, tabSimbolos, currentType, currentTableEntry, currentToken;
    if (token.type == COMMA):
        match(COMMA);
        if (token.type == ID):
            te = TableEntry(token.lexema, currentType, None, None)
            currentTableEntry = te
            tabSimbolos.insertEntry(token.lexema, te)
            match(ID); #cria uma entrada na tabela de símbolos para esse identificador
            return Decl2(no);
    elif (token.type == PCOMMA):
        match(PCOMMA);
        return no
    elif (token.type == ATTR):
        attr_node = Attr()#Cria nó Attr
        id_node = Id(currentTableEntry)
        attr_node.children.append(id_node) #Adiciona o nó Id como primeiro filho do nó Attr
        print('Attr_node: ' + str(attr_node))
        match(ATTR);
        expr_node = E();
        attr_node.children.append(expr_node) #Adiciona o nó Expr como primeiro filho do nó Attr
        print('Attr_node: ' + str(attr_node))
        no.children.append(attr_node) #Adiciona o nó Attr na lista de filhos do nó pai
        print('No pai: ' + str(no))
        return Decl2(no);
    return no;

def Comando(no):
    global token, tabSimbolos, currentType, currentTableEntry, currentToken;
    if (token.type == LBRACE):
        match(LBRACE);
	bloco = Astnode("Bloco");
        Decl_Comando(bloco);
        match(RBRACE);
	no.children.append(bloco);
	return no; 
    if (token.type == ID): #nesse momento, podemos buscar informações sobre esse Id na tabela de símbolos
        attr_node = Attr() #Cria nó Attr
        print('Procurando lexema ' + token.lexema)
        te = tabSimbolos.getEntry(token.lexema)
        id_node = None
        if (te):
            print('Encontrado o lexema na tabela de símbolos.')
            print('Tipo do identificador: ' + str(typeNames[te.tipo]))
            #print('Valor do identificador: ' + str(te.ref_valor))
            id_node = Id(te) #Cria o nó Id passando uma referência para a entrada da tabela de símbolos desse identificador
            attr_node.children.append(id_node) #Adiciona o nó Id como primeiro filho do nó Attr
        match(ID);
        match(ATTR);
        expr_node = E();
        attr_node.children.append(expr_node) #Adiciona o nó Expr como primeiro filho do nó Attr
        match(PCOMMA)
        no.children.append(attr_node); #Adiciona o nó Attr na lista de filhos do nó pai
        return no
    if (token.type == IF):
        ifnode = If() #Cria nó If
        match(IF)
        match(LBRACKET)
        expr_node = E()
        ifnode.children.append(expr_node) #Adiciona o nó expressão como primeiro filho do If
        match(RBRACKET)
        Comando(ifnode) #Chama Comando para preencher os filhos da parte verdadeira do If
        if(token.type == ELSE):
            match(ELSE)
            Comando(ifnode) #Chama Comando para preencher os filhos da parte falsa do If
        no.children.append(ifnode) #Adiciona o nó If na lista de filhos do nó pai
        return no;
    return no

def E():
    global token, tabSimbolos, currentType, currentTableEntry, currentToken;
    no_ope1 = T();
    return E_(no_ope1);

def E_(no_ope1):
    global token, tabSimbolos, currentType, currentTableEntry, currentToken;
    if(token.type == PLUS):
        match(PLUS);
        no_ope2 = T();
        no = ArithOp('+', no_ope1, no_ope2) #Cria um novo nó que representa uma expressão aritmética
        return E_(no);
    elif (token.type == MINUS):
        match(MINUS);
        no_ope2 = T();
        no = ArithOp('-', no_ope1, no_ope2) #Cria um novo nó que representa uma expressão aritmética
        return E_(no);
    return no_ope1

def T():
    global token, tabSimbolos, currentType, currentTableEntry, currentToken;
    no_ope1 = F();
    return T_(no_ope1);

def T_(no_ope1):
    global token, tabSimbolos, currentType, currentTableEntry, currentToken;
    if (token.type == MULT):
        match(MULT);
        no_ope2 = F();
        no = ArithOp('*', no_ope1, no_ope2) #Cria um novo nó que representa uma expressão aritmética
        return T_(no);
    elif(token.type == DIV):
        match(DIV);
        no_ope2 = F();
        no = ArithOp('/', no_ope1, no_ope2) #Cria um novo nó que representa uma expressão aritmética
        return T_(no);
    return no_ope1

def F():
    global token, tabSimbolos, currentType, currentTableEntry, currentToken;
    if(token.type == LBRACKET):
        match(LBRACKET);
        expr = E();
        match(RBRACKET);
        return expr
    elif (token.type == ID):
        te = tabSimbolos.getEntry(token.lexema)
        id_node = None
        if (te):
            print('Encontrado o lexema na tabela de símbolos.')
            print('Tipo do identificador: ' + str(typeNames[te.tipo]))
            id_node = Id(te) #Cria um novo nó que representa um identificador
        match(ID);
        return id_node
    elif(token.type == INTEGER_CONST):
        num_node = Num(token, int_type) #Cria um novo nó que representa um número
        match(INTEGER_CONST)
        return num_node
    elif(token.type == FLOAT_CONST):
        num_node = Num(token, float_type) #Cria um novo nó que representa um número
        match(FLOAT_CONST)
        return num_node

"""
Início da análise sintática de descida recursiva
"""
root = Programa()
print('Árvore de Sintaxe Abstrata: ')
print(str(root))
print('\n-------------')
print('Tabela de símbolos')
print(str(tabSimbolos))
print('-------------')
