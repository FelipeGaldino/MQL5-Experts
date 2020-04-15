//+------------------------------------------------------------------------------------------------------+
//|                                                                                                      |
//|                                                          SALVA A ESTRUTURA MqlTick EM UM ARQUIVO CSV |
//|                                                                                                      |
//+------------------------------------------------------------------------------------------------------+

string LocalSave = TerminalInfoString(TERMINAL_DATA_PATH);

// CSV - VARIAVEIS
int CsvFileCopia;
MqlTick Tick_Last;

// TIME - VARIAVEIS
string TickTime;                                         // TICK - TIME
int TimeModel = TIME_DATE | TIME_MINUTES | TIME_SECONDS; // TIME - FORMATO

//+------------------------------------------------------------------------------------------------------+
//|                     ON-INIT                                                                          |
//+------------------------------------------------------------------------------------------------------+
int OnInit()
{
    // CRIA ARQUIVO CSV
    CsvFileCopia = FileOpen("MeuArquivoTicks.csv", FILE_CSV | FILE_READ | FILE_WRITE | FILE_REWRITE, '\t');

    // CRIA AS COLUNAS DOS ARQUIVO CSV
    FileWrite(CsvFileCopia, "Time_Msc", "DataTime", "Bid", "Ask", "Last", "Volume", "Volume_real", "Spread");

    // MOSTRA ONDE SALVOU O ARQUIVO
    Print("FileOpen OK - O arquivo Foi Criado Em : " + LocalSave + "\\MQL5\\Files");

    return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------------------------------------------+
//|                        ON-TICK                                                                       |
//+------------------------------------------------------------------------------------------------------+
void OnTick()
{

    if (CsvFileCopia != INVALID_HANDLE)
    {
        // POSICIONA O PONTEIRO NO FINAL DO ARQUIVO
        FileSeek(CsvFileCopia, 0, SEEK_END);
    }

    else
        Print("FileOpen Falhou, Erro ", GetLastError());

    // CSV - ESCREVE NO ARQUIVO CSV
    if (CsvFileCopia != INVALID_HANDLE)
    {
        if (SymbolInfoTick(Symbol(), Tick_Last))
        {
            // TIME - CONVERTE OS VALORES PARA STRING
            TickTime = (TimeToString(Tick_Last.time, TimeModel));

            // ESCREVE NO ARQUIVO
            FileWrite(CsvFileCopia, Tick_Last.time_msc, TickTime, Tick_Last.bid,
                      Tick_Last.ask, Tick_Last.last, Tick_Last.volume,
                      Tick_Last.volume_real,
                      StringFormat("%.05f", NormalizeDouble(MathAbs(Tick_Last.bid - Tick_Last.ask), 5)));

            Print("---------ESCREVEU NO ARQUIVO-------------");
        }
        else
            Print("ERROR: SymbolInfoTick() failed to validate tick.");
    }

} // FIM ONTICK

//+------------------------------------------------------------------------------------------------------+
//|                           ON-DEINIT                                                                  |
//+------------------------------------------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // CSV - FECHA O ARQUIVO CSV
    FileClose(CsvFileCopia);
}
