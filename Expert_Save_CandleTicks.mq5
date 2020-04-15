//+------------------------------------------------------------------------------------------------------+
//|                                                                                                      |
//|                                                                        SALVA EM CSV CANDLES DE TICKS |
//|                                                                       BID - ASK - LAST SEPARADAMENTE |
//|                                                                                                      |
//+------------------------------------------------------------------------------------------------------+
#include <Math\Stat\Math.mqh>

// TAMANHO DO CANDLE
input int CandleSize = 5;

// MQL TICK
MqlTick last_tick;

// ASK - VARIAVEIS -----------------------------------------------------------------------

double AskArray[];      // ASK PRICE

double AskVolArray[];   // VOLUME

int AskIndArray = 0;    // CONTADOR ARRAYS

double AskControl;      // CONTROLE TICKS REPETIDOS

int AskHigh;            // MAX CANDLE

int AskLow;             // MIN CANDLE

double AskVolSoma;      // SOMA VOLUME

int AskFor = 0;         // FOR CONTADOR

// BID - VARIAVEIS ------------------------------------------------------------------------

double BidArray[];      // BID PRICE

double BidVolArray[];   // VOLUME

int BidIndArray = 0;    // CONTADOR ARRAYS

double BidControl;      // CONTROLE TICKS REPETIDOS

int BidHigh;            // MAX CANDLE

int BidLow;             // MIN CANDLE

double BidVolSoma;      // SOMA VOLUME

int BidFor = 0;         // FOR CONTADOR

// LAST - VARIAVEIS -----------------------------------------------------------------------

double LastArray[];     // LAST PRICE

double LastVolArray[];  // VOLUME

int LastIndArray = 0;   // CONTADOR ARRAYS

double LastControl;     // CONTROLE TICKS REPETIDOS

int LastHigh;           // MAX CANDLE

int LastLow;            // MIN CANDLE

double LastVolSoma;     // SOMA VOLUME

int LastFor = 0;        // FOR CONTADOR

// SAVE CSV - VARIAVEIS -------------------------------------------------------------------

string LocalSave = TerminalInfoString(TERMINAL_DATA_PATH);  // LOCAL ONDE SALVA O ARQUIVO

string AskFileName = "Ask_CandlesTicks_";                   // DEFINI NOME DO ARQUIVO

string BidFileName = "Bid_CandlesTicks_";                   // DEFINI NOME DO ARQUIVO

string LastFileName = "Last_CandlesTicks_";                 // DEFINI NOME DO ARQUIVO

int AskCsv;                                                 // MANIPULAR O ARQUIVO

string AskFile;                                             // NOME DE ACORDO COM CANDLES

string BidFile;                                             // NOME DE ACORDO COM CANDLES

string LastFile;                                            // NOME DE ACORDO COM CANDLES

string TickString;                                          // CONVERTE PARA STRING A QNT DE CANDLES

int BidCsv;                                                 // MANIPULAR O ARQUIVO

int LastCsv;                                                // MANIPULAR O ARQUIVO


//+------------------------------------------------------------------------------------------------------+
//|                     ON-INIT                                                                          |
//+------------------------------------------------------------------------------------------------------+
int OnInit()
{
    // CSV - CONVERTE PARA O NOME DO ARQUIVO
    TickString = IntegerToString(CandleSize);

    // CSV - NOME DO ARQUIVO
    AskFile = AskFileName + TickString;
    BidFile = BidFileName + TickString;
    LastFile = LastFileName + TickString;

    // CSV - CRIA ARQUIVO CSV
    AskCsv = FileOpen(AskFile + ".csv", FILE_CSV | FILE_READ | FILE_WRITE | FILE_REWRITE, '\t');

    BidCsv = FileOpen(BidFile + ".csv", FILE_CSV | FILE_READ | FILE_WRITE | FILE_REWRITE, '\t');

    LastCsv = FileOpen(LastFile + ".csv", FILE_CSV | FILE_READ | FILE_WRITE | FILE_REWRITE, '\t');

    // CSV - CRIA AS COLUNAS DOS ARQUIVO CSV
    FileWrite(AskCsv, "Ask CandlesTicks", "DateTime", "Open", "High", "Low", "Close", "Volume");

    FileWrite(BidCsv, "Bid CandlesTicks", "DateTime", "Open", "High", "Low", "Close", "Volume");

    FileWrite(LastCsv, "Last CandlesTicks", "DateTime", "Open", "High", "Low", "Close", "Volume");

    // CSV - MOSTRA ONDE SALVOU O ARQUIVO
    Print("FileOpen OK - Os arquivo Foram Criados Em : " + LocalSave + "\\MQL5\\Files");

    // ASK - ORDENA O ARRAY POR TEMPO
    ArraySetAsSeries(AskArray, true);

    // ASK - DEFINI O TAMANHO DO ARRAY
    ArrayResize(AskArray, CandleSize, 10);

    // ASK VOLUME - ORDENA O ARRAY POR TEMPO
    ArraySetAsSeries(AskVolArray, true);

    // ASK VOLUME - DEFINI O TAMANHO DO ARRAY
    ArrayResize(AskVolArray, CandleSize, 10);

    // BID - ORDENA O ARRAY POR TEMPO
    ArraySetAsSeries(BidArray, true);

    // BID - DEFINI O TAMANHO DO ARRAY
    ArrayResize(BidArray, CandleSize, 10);

    // BID VOLUME - ORDENA O ARRAY POR TEMPO
    ArraySetAsSeries(BidVolArray, true);

    // BID VOLUME - DEFINI O TAMANHO DO ARRAY
    ArrayResize(BidVolArray, CandleSize, 10);

    // LAST - ORDENA O ARRAY POR TEMPO
    ArraySetAsSeries(LastArray, true);

    // LAST - DEFINI O TAMANHO DO ARRAY
    ArrayResize(LastArray, CandleSize, 10);

    // LAST VOLUME - ORDENA O ARRAY POR TEMPO
    ArraySetAsSeries(LastVolArray, true);

    // LAST VOLUME - DEFINI O TAMANHO DO ARRAY
    ArrayResize(LastVolArray, CandleSize, 10);

    return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//|                           ON-TICK                                 |
//+------------------------------------------------------------------+
void OnTick()
{
    // ATRIBUI OS TICKS A VARIAVEL
    SymbolInfoTick(_Symbol, last_tick);

    //------------------------------------------------------ ASK - FORMANDO BARRAS DE ASK ----------------------------------------

    // ASK - ATRIBUI OS VALORES DE ASK AO INDICE DO ARRAY
    if (AskControl != last_tick.ask)
    {

        // ASK VOLUME - ARRAY PARA ARMAZENAR O VOLUME
        AskVolArray[AskIndArray] = last_tick.volume_real;

        // ASK ARRAY - PARA ARMAZENAR O VALOR DE ASK
        AskArray[AskIndArray] = last_tick.ask;

        // ASK - CONTROLE PARA NAO VIR TICKS DUPLICADOS
        AskControl = last_tick.ask;

        // ASK - INCREMENTA O INDICE DE TODOS OS  ARRAY
        AskIndArray++;

        if (AskIndArray == CandleSize)
        {

            // ASK VOLUME - SOMA DO VOLUME DE TICKS NO CANDLE
            AskVolSoma = MathSum(AskVolArray);

            // ASK - DEFINI PRECO MAXIMO NO ARRAY
            AskHigh = ArrayMaximum(AskArray, 0, CandleSize);

            // ASK - DEFINI PRECO MINIMO NO ARRAY
            AskLow = ArrayMinimum(AskArray, 0, CandleSize);

            // ASK - CONFERE OS TICKS
            for (AskFor = 0; AskFor < CandleSize; AskFor++)
            {
                Print(" Numero do Tick = ", AskFor, " Tick Ask : ", AskArray[AskFor], " Volume Ask : ", AskVolArray[AskFor]);
            }

            // ASK - MONTA A BARRA
            Print(" Ask Candle = Ticks : ", AskIndArray, " Datetime : ", last_tick.time, " Open : ", AskArray[0], " High : ", 
                    AskArray[AskHigh], " Low : ", AskArray[AskLow], " Close : ", AskArray[CandleSize - 1], " Volume : ", AskVolSoma);

            // ASK CSV - POSICIONA O PONTEIRO NO FINAL DO ARQUIVO
            FileSeek(AskCsv, 0, SEEK_END);

            // ASK CSV - ESCREVE NO ARQUIVO
            FileWrite(AskCsv, AskIndArray, last_tick.time, AskArray[0], AskArray[AskHigh], AskArray[AskLow],
                      AskArray[CandleSize - 1], AskVolSoma);

            Print("---------ESCREVEU NO ARQUIVO ASK-------------");

            // ASK - ZERA AS VARIAVEIS
            ZeroMemory(AskIndArray);
            ZeroMemory(AskHigh);
            ZeroMemory(AskLow);

            // ASK - REINICIA OS ARRAYS
            ArrayFree(AskArray);
            ArrayResize(AskArray, CandleSize, 10);

            // ASK VOLUME - ZERA AS VARIAVEIS
            ZeroMemory(AskVolSoma);

            // ASK VOLUME - REINICIA OS ARRAYS
            ArrayFree(AskVolArray);
            ArrayResize(AskVolArray, CandleSize, 10);

        } // ASK- FIM DO IF FORMADOR DA BARRA ASK
    }     // ASK- FIM DO IF CONTADOR TICKS ASK

    //------------------------------------------------------ BID - FORMANDO BARRAS DE BID ------------------------------------------

    // BID - ATRIBUI OS VALORES DE BID AO INDICE DO ARRAY
    if (BidControl != last_tick.bid)
    {

        // BID VOLUME - ARRAY
        BidVolArray[BidIndArray] = last_tick.volume_real;

        // BID - ARRAY
        BidArray[BidIndArray] = last_tick.bid;

        // BID - CONTROLE PARA NAO VIR TICKS DUPLICADOS
        BidControl = last_tick.bid;

        // BID - INCREMENTA O INDICE DO ARRAY
        BidIndArray++;

        if (BidIndArray == CandleSize)
        {
            // BID VOLUME - SOMA DO VOLUME DE TICKS NO CANDLE
            BidVolSoma = MathSum(BidVolArray);

            // BID - DEFINI PRECO MAXIMO NO ARRAY
            BidHigh = ArrayMaximum(BidArray, 0, CandleSize);

            // BID - DEFINI PRECO MINIMO NO ARRAY
            BidLow = ArrayMinimum(BidArray, 0, CandleSize);

            // BID - CONFERE OS TICKS
            for (BidFor = 0; BidFor < CandleSize; BidFor++)
            {
                Print(" Numero do Tick = ", BidFor, " Tick Bid : ", BidArray[BidFor], " Volume Bid : ", BidVolArray[BidFor]);
            }

            // BID - MONTA A BARRA
            Print(" Bid Candle = Ticks : ", BidIndArray, " Datetime : ", last_tick.time, " Open : ", BidArray[0], " High : ", 
                    BidArray[BidHigh], " Low : ", BidArray[BidLow], " Close : ", BidArray[CandleSize - 1], " Volume ", BidVolSoma);

            // BID CSV - POSICIONA O PONTEIRO NO FINAL DO ARQUIVO
            FileSeek(BidCsv, 0, SEEK_END);

            // BID CSV - ESCREVE NO ARQUIVO
            FileWrite(BidCsv, BidIndArray, last_tick.time, BidArray[0], BidArray[BidHigh], BidArray[BidLow],
                      BidArray[CandleSize - 1], BidVolSoma);

            // BID CSV - CONFIRMA QUE ESCREVEU NO ARQUIVO
            Print("---------ESCREVEU NO ARQUIVO BID-------------");

            // BID - ZERA AS VARIAVEIS
            ZeroMemory(BidIndArray);
            ZeroMemory(BidHigh);
            ZeroMemory(BidLow);

            // BID - REINICIA OS ARRAYS
            ArrayFree(BidArray);
            ArrayResize(BidArray, CandleSize, 10);

            // BID VOLUME - ZERA AS VARIAVEIS
            ZeroMemory(BidVolSoma);

            // BID VOLUME - REINICIA OS ARRAYS
            ArrayFree(BidVolArray);
            ArrayResize(BidVolArray, CandleSize, 10);

        } // BID- FIM DO IF FORMADOR DA BARRA ASK
    }     // BID- FIM DO IF CONTADOR TICKS ASK

    //------------------------------------------------------ LAST - FORMANDO BARRAS DE LAST ----------------------------------------

    // LAST - ATRIBUI OS VALORES DE ASK AO INDICE DO ARRAY
    if (LastControl != last_tick.last)
    {

        // LAST VOLUME - ARRAY
        LastVolArray[LastIndArray] = last_tick.volume_real;

        // LAST - ARRAY
        LastArray[LastIndArray] = last_tick.last;

        // LAST - CONTROLE PARA NAO VIR TICKS DUPLICADOS
        LastControl = last_tick.last;

        // LAST - INCREMENTA O INDICE DO ARRAY
        LastIndArray++;

        if (LastIndArray == CandleSize)
        {

            // BID VOLUME - SOMA DO VOLUME DE TICKS NO CANDLE
            LastVolSoma = MathSum(LastVolArray);

            // LAST - DEFINI PRECO MAXIMO NO ARRAY
            LastHigh = ArrayMaximum(LastArray, 0, CandleSize);

            // LAST - DEFINI PRECO MINIMO NO ARRAY
            LastLow = ArrayMinimum(LastArray, 0, CandleSize);

            // LAST - CONFERE OS TICKS
            for (LastFor = 0; LastFor < CandleSize; LastFor++)
            {
                Print(" Numero do Tick = ", LastFor, " Tick Last : ", LastArray[LastFor], " Volume Last : ", LastVolArray[LastFor]);
            }

            // LAST - MONTA A BARRA
            Print(" Last Candles = Ticks : ", LastIndArray, " Datetime : ", last_tick.time, " Open : ", LastArray[0], " High : ", 
                    LastArray[LastHigh], " Low : ", LastArray[LastLow], " Close : ", LastArray[CandleSize - 1], " Volume ", LastVolSoma);

            // LAST CSV - POSICIONA O PONTEIRO NO FINAL DO ARQUIVO
            FileSeek(LastCsv, 0, SEEK_END);

            // LAST CSV - ESCREVE NO ARQUIVO
            FileWrite(LastCsv, LastIndArray, last_tick.time, LastArray[0], LastArray[LastHigh], LastArray[LastLow],
                      LastArray[CandleSize - 1], LastVolSoma);

            // LAST CSV - CONFIRMA QUE ESCREVEU NO ARQUIVO
            Print("---------ESCREVEU NO ARQUIVO LAST-------------");

            // LAST - ZERA AS VARIAVEIS
            ZeroMemory(LastIndArray);
            ZeroMemory(LastHigh);
            ZeroMemory(LastLow);

            // LAST - REINICIA OS ARRAYS
            ArrayFree(LastArray);
            ArrayResize(LastArray, CandleSize, 10);

            // LAST VOLUME - ZERA AS VARIAVEIS
            ZeroMemory(LastVolSoma);

            // LAST VOLUME - REINICIA OS ARRAYS
            ArrayFree(LastVolArray);
            ArrayResize(LastVolArray, CandleSize, 10);

        } // LAST - FIM DO IF FORMADOR DA BARRA ASK
    }     // LAST- FIM DO IF CONTADOR TICKS ASK
} // FIM ONTICK

//+------------------------------------------------------------------------------------------------------+
//|                           ON-DEINIT                                                                  |
//+------------------------------------------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // CSV - FECHA O ARQUIVO CSV
    FileClose(AskCsv);
    FileClose(BidCsv);
    FileClose(LastCsv);
}