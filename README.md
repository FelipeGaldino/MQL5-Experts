# Guia Inicial Experts-MQL5

Guia inicial com alguns exemplos simples de Experts com MQL5.

## Instalando o Metatrader5

O Metatrader é compativel apenas com o Windows até o momento segue abaixo o link para o download.

* [Metatrader5](https://www.metatrader5.com/pt/download) - Link para Download.

### Configurando 

Após instalado o Metatrader sera necessario logar com a conta fornecida pela Corretora para poder baixar os dados do ativo, abaixo segue os links de duas corretoras.

* [ICMarkets](https://www.icmarkets.com/sc/pt/) - Corretora para trabalhar com o mercado de Forex.

* [XPInvestimentos](https://www.xpi.com.br/) - Corretora para trabalhar com o mercado Brasileiro.

## MetaEditor

* Clique no Icone com o numero 5 para iniciar o MetaEditor.
![Screenshot](https://user-images.githubusercontent.com/45602322/79400277-c3127000-7f53-11ea-92a0-536ebd01d3ce.png)

* Criaremos um novo projeto clicando em Novo.
* Expert Advisor.
* Escolha um Nome.
* Next-Next Finish.

### Funções principais do Expert-Advisor

OnInit - Esta Função é chamada apenas ao iniciar o Expert Advisor.

```
int OnInit()
  {
  }
```

OnDeinit - Esta Função é chamada apenas ao retirar o Expert Advisor do grafico ou desligar o backtest.

```
void OnDeinit(const int reason)
  {
  }
```
OnTick - Esta Função é chamada a cada Tick gerado no grafico, em geral a logica da estrategia é toda feita dentro dessa função.

```
void OnTick()
  {
  }
```

## Documentação

Abaixo estão alguns links para a documentação da ferramenta e do forum onde é possivel tirar varias duvidas.

* [Metatrader](https://www.metatrader5.com/pt/trading-platform) - Corretora para trabalhar com o mercado de Forex.

* [Forum](https://www.mql5.com/) - Corretora para trabalhar com o mercado de Forex.

* [Documentação](https://www.mql5.com/pt/docs) - Corretora para trabalhar com o mercado de Forex.


## Autor

* **Felipe Galdino** - *Github* - [FelipeGaldino](https://github.com/FelipeGaldino)


