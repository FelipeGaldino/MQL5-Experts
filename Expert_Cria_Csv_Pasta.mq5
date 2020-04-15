//+---------------------------------------------------------------------------------+
//|                                                                                 |
//|                                                      SALVA TICKS NO ARQUIVO CSV |
//|                                                                 CRIA PASTA      |
//+---------------------------------------------------------------------------------+

string CaminhoDados = TerminalInfoString(TERMINAL_DATA_PATH);
int CsvFileCopia;
string PastaCria = "Dados";

//+---------------------------------------------------------------------------------+
//|                                                                                 |
//+---------------------------------------------------------------------------------+
int OnInit()
{
    Print("O arquivo TXT criado em " + CaminhoDados + "\\MQL5\\Files\\" + PastaCria);
    Print("O arquivo CSV FOI criado em " + CaminhoDados + "\\MQL5\\Files");
    return (INIT_SUCCEEDED);
}

//+---------------------------------------------------------------------------------+
//|                                                                                 |
//+---------------------------------------------------------------------------------+
void OnTick()
{
    // CSV - CRIA ARQUIVO
    CsvFileCopia = FileOpen("MeuArquivo.csv", FILE_WRITE | FILE_CSV);
    if (CsvFileCopia != INVALID_HANDLE)
    {
        // CSV - ESCREVE ARQUIVO
        FileWrite(CsvFileCopia, TimeCurrent(), Symbol(), EnumToString(_Period));

        // CSV - FECHA ARQUIVO
        FileClose(CsvFileCopia);
        Print("FileOpen OK");
    }
    else
        Print("FileOpen falhou, erro ", GetLastError());

    // TXT -CRIA DIRETORIO E SALVA
    CsvFileCopia = FileOpen(PastaCria + "\\MeuArquivo.txt", FILE_WRITE | FILE_CSV);
    if (CsvFileCopia != INVALID_HANDLE)
    {
        // TXT - ESCREVE ARQUIVO
        FileWrite(CsvFileCopia, TimeCurrent(), Symbol(), EnumToString(_Period));

        // TXT - ESCREVE ARQUIVO
        FileClose(CsvFileCopia);
    }
    else
        Print("Falha ao abrir arquivo, erro ", GetLastError());

} // FECHA ONTICK
