//+------------------------------------------------------------------+
//| EA BUSCA INDICADOR CUSTOMIZADO                                   |
//+------------------------------------------------------------------+
#property tester_indicator "Indicator_Custom_Ticks_Bid_Ask.ex5"
#include <Trade\Trade.mqh>

// VARIAVEL PARA O INDICADOR
int Indicador; 

//+------------------------------------------------------------------+
//| Função de iteração de indicador personalizado                    |
//+------------------------------------------------------------------+
void OnInit()
  {
   // INICIA O INDICADOR NO GRAFICO
   Indicador=iCustom(_Symbol,0,"Indicator_Custom_Ticks_Bid_Ask");
   
   Print(" O Indicador Carregado foi o : ",Indicador);
  }
  
void OnTick()
  {
   
  }

void OnDeinit(const int reason)
  {
   
  }