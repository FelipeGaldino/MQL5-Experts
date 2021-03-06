//+------------------------------------------------------------------+
//|                                                                  |
//|             CONTADOR DE TICKS                                    |
//|                                                                  |
//+------------------------------------------------------------------+

// VARIAVEIS DO CONTADOR
int BidCounter;
int AskCounter;

// VARIAVEIS DE CONTROLE
double BidControl;
double AskControl;

// VARIAVEIS QUE RECEBEM OS TICKS
double Ask;
double Bid;

//+------------------------------------------------------------------+
//|                     ON-TICKS                                     |
//+------------------------------------------------------------------+
void OnTick()
  {
// ASK - PEGA O VALOR DO ASK DO SIMBOLO CORRENTE
    Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

// BID - PEGA O VALOR DO BID DO SIMBOLO CORRENTE
    Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

// BID - CONTADOR
   if(BidControl!=Bid)
     {
      BidCounter++;
      Print(" Numero do Tick = ", BidCounter," Tick Bid = ", Bid);
     }

// ASK - CONTADOR
   if(AskControl!=Ask)
     {
      AskCounter++;
      Print(" Numero do Tick = ", AskCounter," Tick Ask = ", Ask);
     }

  } // FECHA ONTICK

