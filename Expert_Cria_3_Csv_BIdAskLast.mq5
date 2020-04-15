//+------------------------------------------------------------------------------------------------------+
//|                                                                                                      |
//|                                                         CRIA 3 ARQUIVOS CSV PARA ARMAZENAR OS PRECOS |
//|                                                                       BID - ASK - LAST SEPARADAMENTE |
//|                                                                                                      |
//+------------------------------------------------------------------------------------------------------+

// ASK - VARIAVEIS
int AskCsv;
double AskTickCount;

// BID - VARIAVEIS
int BidCsv;
double BidTickCount;

// LAST - VARIAVEIS
int LastCsv;
double LastTickCount;

MqlTick Tick_Last;

// TIME - VARIAVEIS
string TickTime;                                         // TICK - TIME
int TimeModel = TIME_DATE | TIME_MINUTES | TIME_SECONDS; // TIME - FORMATO

// TICK - LOCAL ONDE E SALVO
string LocalSave = TerminalInfoString(TERMINAL_DATA_PATH);

//+------------------------------------------------------------------------------------------------------+
//|                     ON-INIT                                                                          |
//+------------------------------------------------------------------------------------------------------+
int OnInit()
{
    // CRIA ARQUIVO CSV
    AskCsv = FileOpen("AskTicksBacktest.csv", FILE_CSV | FILE_READ | FILE_WRITE | FILE_REWRITE, '\t');

    BidCsv = FileOpen("BidTicksBacktest.csv", FILE_CSV | FILE_READ | FILE_WRITE | FILE_REWRITE, '\t');

    LastCsv = FileOpen("LastTicksBacktest.csv", FILE_CSV | FILE_READ | FILE_WRITE | FILE_REWRITE, '\t');

    // CRIA AS COLUNAS DOS ARQUIVO CSV
    FileWrite(AskCsv, "Time_Msc", "DataTime", "Ask", "Volume", "Volume_real");

    FileWrite(BidCsv, "Time_Msc", "DataTime", "Ask", "Volume", "Volume_real");

    FileWrite(LastCsv, "Time_Msc", "DataTime", "Ask", "Volume", "Volume_real");

    // MOSTRA ONDE SALVOU O ARQUIVO
    Print("FileOpen OK - Os arquivo Foram Criados Em : " + LocalSave + "\\MQL5\\Files");

    return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------------------------------------------+
//|                        ON-TICK                                                                       |
//+------------------------------------------------------------------------------------------------------+
void OnTick()
{

    SymbolInfoTick(Symbol(), Tick_Last);
    // ASK - ARMAZENA OS DADOS DE ASK NO ARQUIVO

    if (AskTickCount != Tick_Last.ask)
    {
        // ASK - POSICIONA O PONTEIRO NO FINAL DO ARQUIVO
        FileSeek(AskCsv, 0, SEEK_END);

        // TIME - CONVERTE OS VALORES PARA STRING
        TickTime = (TimeToString(Tick_Last.time, TimeModel));

        // ESCREVE NO ARQUIVO
        FileWrite(AskCsv, Tick_Last.time_msc, TickTime, Tick_Last.ask,
                  Tick_Last.volume, Tick_Last.volume_real);

        AskTickCount = Tick_Last.ask;
        Print("---------ESCREVEU NO ARQUIVO ASK-------------");
    }
    else
    {
        Print(" Tick Duplicado Ask. ");
    }

    // BID - ARMAZENA OS DADOS DE BID NO ARQUIVO
    if (BidTickCount != Tick_Last.bid)
    {

        // ASK - POSICIONA O PONTEIRO NO FINAL DO ARQUIVO
        FileSeek(BidCsv, 0, SEEK_END);

        // TIME - CONVERTE OS VALORES PARA STRING
        TickTime = (TimeToString(Tick_Last.time, TimeModel));

        // ESCREVE NO ARQUIVO
        FileWrite(BidCsv, Tick_Last.time_msc, TickTime, Tick_Last.bid,
                  Tick_Last.volume, Tick_Last.volume_real);

        BidTickCount = Tick_Last.bid;
        Print("---------ESCREVEU NO ARQUIVO BID-------------");
    }
    else
    {
        Print(" Tick Duplicado Bid. ");
    }

    // LAST - ARMAZENA OS DADOS DE LAST NO ARQUIVO
    if (LastTickCount != Tick_Last.last)
    {
        // LAST - POSICIONA O PONTEIRO NO FINAL DO ARQUIVO
        FileSeek(LastCsv, 0, SEEK_END);

        // TIME - CONVERTE OS VALORES PARA STRING
        TickTime = (TimeToString(Tick_Last.time, TimeModel));

        // LAST - ESCREVE NO ARQUIVO
        FileWrite(LastCsv, Tick_Last.time_msc, TickTime, Tick_Last.last,
                  Tick_Last.volume, Tick_Last.volume_real);

        LastTickCount = Tick_Last.last;
        Print("---------ESCREVEU NO ARQUIVO LAST-------------");
    }
    else
    {
        Print(" Tick Duplicado em Last. ");
    }

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
