# Compilador C-Small em Ruby
Os resultados estão na pasta Resultados, e contem os arquivos
- [x] ASA.xml
- [x] codPython.py
- [x] AnaliseSintatica.txt

## Exemplo Código em C - Entrada
```C
int main() {

  int a = 10, b = 5;
  int i;

  for (i = 0; i < 10; i = i + 1)  {
    if (a < 10)     {
      a = (b + 1) * 3;
    } else {
      a = 30;
    }
    b = 60;
  }
}
```
### AST 
```xml
<AST>
    <Attr>
        <Id lexema='a' type='Integer'/>
        <Num value= 10 type='Integer'/>
    </Attr>
    <Attr>
        <Id lexema='b' type='Integer'/>
        <Num value= 5 type='Integer'/>
    </Attr>
    <For>
        <Attr>
            <Id lexema='i' type='Integer'/>
            <Num value= 0 type='Integer'/>
        </Attr>
        <RelOp op='<'>
            <Id lexema='i' type='Integer'/>
            <Num value= 10 type='Integer'/>
        </RelOp>
        <Attr>
            <Id lexema='i' type='Integer'/>
            <ArithOp op='+'>
                <Id lexema='i' type='Integer'/>
                <Num value= 1 type='Integer'/>
            </ArithOp>
        </Attr>
        <Bloco>
            <If>
                <RelOp op='<'>
                    <Id lexema='a' type='Integer'/>
                    <Num value= 10 type='Integer'/>
                </RelOp>
                    <Bloco>
                        <Attr>
                            <Id lexema='a' type='Integer'/>
                            <ArithOp op='*'>
                                <ArithOp op='+'>
                                    <Id lexema='b' type='Integer'/>
                                    <Num value= 1 type='Integer'/>
                                </ArithOp>
                                <Num value= 3 type='Integer'/>
                            </ArithOp>
                        </Attr>
                    </Bloco>
                    <Bloco>
                        <Attr>
                            <Id lexema='a' type='Integer'/>
                            <Num value= 30 type='Integer'/>
                        </Attr>
                    </Bloco>
            </If>
            <Attr>
                <Id lexema='b' type='Integer'/>
                <Num value= 60 type='Integer'/>
            </Attr>
        </Bloco>
    </For>
</AST>
```
### Geração de Código Python - Saída
```python
a = 10
b = 5
i = 0
while i < 10:
    if a < 10:
        a = (b + 1) * 3
    else:
        a = 30
    b = 60
    i = i + 1
```
