//+------------------------------------------------------------------+
//|                                                                  |
//|   INDICADOR QUE PLOTA O GRAFIC DE TICKS BID ASK                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   4

//--- PLOTA BID
#property indicator_label1  "Bid"
#property indicator_type1   DRAW_LINE
#property indicator_color1  Blue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

//--- PLOTA ASK
#property indicator_label2  "Ask"
#property indicator_type2   DRAW_LINE
#property indicator_color2  Red
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

//--- BUFFER DO INDICADOR
double  BidBuffer[];
double  AskBuffer[];

//--- TICKS CONTADOR
static int ticks=0;

//+------------------------------------------------------------------+
//| INICIALIZA CUSTOM INDICATOR                                      |
//+------------------------------------------------------------------+
int OnInit()
  {

   // MAPEANDO OS BUFFERS
   SetIndexBuffer(0,BidBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,AskBuffer,INDICATOR_DATA);

   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0);
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,0);
   
   ArrayInitialize(AskBuffer,0);
   ArrayInitialize(BidBuffer,0);

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| CUSTOM INDICATOR                                                 |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
   {

   MqlTick last_tick;
   if(SymbolInfoTick(Symbol(),last_tick))
     {
  
      BidBuffer[ticks]=last_tick.bid;
      AskBuffer[ticks]=last_tick.ask;

      int shift=rates_total-1-ticks;
      ticks++;

      PlotIndexSetInteger(0,PLOT_SHIFT,shift);
      PlotIndexSetInteger(1,PLOT_SHIFT,shift);

      Comment(" Bid = ",last_tick.bid," Ask = ",last_tick.ask, " Last ",last_tick.last, " Volume ",last_tick.volume);
      Print(" Bid = ", last_tick.bid,"   Ask = ",last_tick.ask, " Last ",last_tick.last, " Volume ",last_tick.volume, " Ticks ",ticks);
      
     } // FECHA IF MQLTICK

   return(rates_total);
   
  } // FECHA ON CALCULATE

//+------------------------------------------------------------------+
//| DESINICIALIZA O INDICADOR                                        |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Comment(" Fechando o Indicador ");
  }

