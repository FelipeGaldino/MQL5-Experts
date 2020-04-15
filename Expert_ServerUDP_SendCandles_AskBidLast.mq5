//+------------------------------------------------------------------+
//|                                                                  |
//|                           ENVIA PARA O CLIENT BARRAS DE TICK ASK |
//|                                                                  |
//+------------------------------------------------------------------+

// SOCKET MSG - VARIAVEIS --------------------------------------------
#include <socketlib.mqh>      // CONEXAO SOCKET
#include <Trade\Trade.mqh>    // TRADE
#include <Math\Stat\Math.mqh> // OPERACOES MATEMATICAS
CTrade trade;

// TIPO DE BARRA  ----------------------------------------------------
enum Swap
{
    Ask,
    Bid,
    Last,
};
input Swap TipoBarra = Ask;

// TAMANHO DO CANDLE -------------------------------------------------
input int CandleSize = 10;

// MQL TICK ----------------------------------------------------------
MqlTick last_tick;

// TIME MODEL --------------------------------------------------------
int TimeModel = TIME_DATE | TIME_SECONDS; // TIME - FORMATO

// SOCKET MSG - INPUTS -----------------------------------------------
input string Host = "127.0.0.1"; // HOST
input ushort Port = 8888;        // PORTA

// SOCKET TRADE - VARIAVEIS PARA TRADE -------------------------------
double Lote;
double TakeProfit;
double StopLoss;

// SOCKET MSG - ARMAZENA A MENSAGEM ----------------------------------
string Msg;

// SOCKET MSG - CLIENTE SOCKET ---------------------------------------
SOCKET64 server = INVALID_SOCKET64;

// ASK - VARIAVEIS----------------------------------------------------

double AskArray[]; // ASK PRICE

double AskVolArray[]; // VOLUME

int AskIndArray = 0; // CONTADOR ARRAYS

double AskControl; // CONTROLE TICKS REPETIDOS

int AskHigh; // MAX CANDLE

int AskLow; // MIN CANDLE

double AskVolSoma; // SOMA VOLUME

int AskFor = 0; // FOR CONTADOR

// ASK MSG -----------------------------------------------------------

string AskStrOpenMsg;

string AskStrHighMsg;

string AskStrLowMsg;

string AskStrCloseMsg;

string AskVolStrMsg;

string AskTickStrTime;

string AskTickStrCount;

// BID - VARIAVEIS --------------------------------

double BidArray[]; // BID PRICE

double BidVolArray[]; // VOLUME

int BidIndArray = 0; // CONTADOR ARRAYS

double BidControl; // CONTROLE TICKS REPETIDOS

int BidHigh; // MAX CANDLE

int BidLow; // MIN CANDLE

double BidVolSoma; // SOMA VOLUME

int BidFor = 0; // FOR CONTADOR

// BID MSG -----------------------------------------------------------

string BidStrOpenMsg;

string BidStrHighMsg;

string BidStrLowMsg;

string BidStrCloseMsg;

string BidVolStrMsg;

string BidTickStrTime;

string BidTickStrCount;

// LAST - VARIAVEIS----------------------------------------------------

double LastArray[]; // LAST PRICE

double LastVolArray[]; // VOLUME

int LastIndArray = 0; // CONTADOR ARRAYS

double LastControl; // CONTROLE TICKS REPETIDOS

int LastHigh; // MAX CANDLE

int LastLow; // MIN CANDLE

double LastVolSoma; // SOMA VOLUME

int LastFor = 0; // FOR CONTADOR

// LAST MSG -----------------------------------------------------------

string LastStrOpenMsg;

string LastStrHighMsg;

string LastStrLowMsg;

string LastStrCloseMsg;

string LastVolStrMsg;

string LastTickStrTime;

string LastTickStrCount;

//+------------------------------------------------------------------+
//|                             ON-INIT                              |
//+------------------------------------------------------------------+
void OnInit()
{
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
}
//+------------------------------------------------------------------+
//|                           ON-TICK                                 |
//+------------------------------------------------------------------+
void OnTick()
{

    // ATRIBUI OS TICKS A VARIAVEL
    SymbolInfoTick(_Symbol, last_tick);

    //------------------------------------------------------ ASK - FORMANDO BARRAS DE ASK ----------------------------------------------------------------------|
    if (TipoBarra == Ask)
    {

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

                // ASK MSG - CONVERTE PARA STRING
                AskStrOpenMsg = (DoubleToString(AskArray[0], Digits()));
                AskStrHighMsg = (DoubleToString(AskArray[AskHigh], Digits()));
                AskStrLowMsg = (DoubleToString(AskArray[AskLow], Digits()));
                AskStrCloseMsg = (DoubleToString(AskArray[CandleSize - 1], Digits()));

                // ASK MSG - TIME CONVERTE OS VALORES PARA STRING
                AskTickStrTime = (TimeToString(last_tick.time, TimeModel));

                // ASK MSG - VOLUME CONVERTE PARA STRING
                AskVolStrMsg = (DoubleToString(AskVolSoma, Digits()));

                // ASK MSG - COUNT CONVERTE PARA STRING
                AskTickStrCount = (DoubleToString(AskIndArray, Digits()));

                // ASK - MONTA A BARRA
                Print(" Ask Candle = Ticks : " + AskTickStrCount + " Datetime : " + AskTickStrTime + " Open : " + AskStrOpenMsg + " High : " + AskStrHighMsg +
                      " Low : " + AskStrLowMsg + " Close : " + AskStrCloseMsg + " Volume : " + AskVolStrMsg);

                // ASK MSG - CRIA A MENSAGEM
                Msg = (" Ask Candle = Ticks : " + AskTickStrCount + " Datetime : " + AskTickStrTime + " Open : " + AskStrOpenMsg + " High : " + AskStrHighMsg +
                       " Low : " + AskStrLowMsg + " Close : " + AskStrCloseMsg + " Volume : " + AskVolStrMsg);

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

            }// ASK - FECHA IF DA BARRA
        }// ASK - FECHA IF DO CONTROLE DE TICKS REPETIDOS
    }// ASK - FECHA TIPO BARRA

    //------------------------------------------------------ BID - FORMANDO BARRAS DE BID ----------------------------------------------------------------------|
    if (TipoBarra == Bid)
    {
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

                // BID MSG - CONVERTE PARA STRING
                BidStrOpenMsg = (DoubleToString(BidArray[0], Digits()));
                BidStrHighMsg = (DoubleToString(BidArray[BidHigh], Digits()));
                BidStrLowMsg = (DoubleToString(BidArray[BidLow], Digits()));
                BidStrCloseMsg = (DoubleToString(BidArray[CandleSize - 1], Digits()));

                // BID MSG - TIME CONVERTE OS VALORES PARA STRING
                BidTickStrTime = (TimeToString(last_tick.time, TimeModel));

                // BID MSG - VOLUME CONVERTE PARA STRING
                BidVolStrMsg = (DoubleToString(BidVolSoma, Digits()));

                // BID MSG - COUNT CONVERTE PARA STRING
                BidTickStrCount = (DoubleToString(BidIndArray, Digits()));

                // BID - MONTA A BARRA
                Print(" Bid Candle = Ticks : " + BidTickStrCount + " Datetime : " + BidTickStrTime + " Open : " + BidStrOpenMsg + " High : " + BidStrHighMsg +
                      " Low : " + BidStrLowMsg + " Close : " + BidStrCloseMsg + " Volume : " + BidVolStrMsg);

                // BID MSG - CRIA A MENSAGEM
                Msg = (" Bid Candle = Ticks : " + BidTickStrCount + " Datetime : " + BidTickStrTime + " Open : " + BidStrOpenMsg + " High : " + BidStrHighMsg +
                       " Low : " + BidStrLowMsg + " Close : " + BidStrCloseMsg + " Volume : " + BidVolStrMsg);

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

            }// BID- FIM DO IF FORMADOR DA BARRA ASK
        }// BID- FIM DO IF CONTADOR TICKS ASK
    }// BID - FECHA TIPO BARRA

    //------------------------------------------------------ LAST - FORMANDO BARRAS DE LAST -----------------------------------------------------------------|
    if (TipoBarra == Last)
    {
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

                // LAST MSG - CONVERTE PARA STRING
                LastStrOpenMsg = (DoubleToString(LastArray[0], Digits()));
                LastStrHighMsg = (DoubleToString(LastArray[LastHigh], Digits()));
                LastStrLowMsg = (DoubleToString(LastArray[LastLow], Digits()));
                LastStrCloseMsg = (DoubleToString(LastArray[CandleSize - 1], Digits()));

                // LAST MSG - TIME CONVERTE OS VALORES PARA STRING
                LastTickStrTime = (TimeToString(last_tick.time, TimeModel));

                // LAST MSG - VOLUME CONVERTE PARA STRING
                LastVolStrMsg = (DoubleToString(LastVolSoma, Digits()));

                // LAST MSG - COUNT CONVERTE PARA STRING
                LastTickStrCount = (DoubleToString(LastIndArray, Digits()));

                // LAST - MONTA A BARRA
                Print(" Last Candle = Ticks : " + LastTickStrCount + " Datetime : " + LastTickStrTime + " Open : " + LastStrOpenMsg + " High : " + LastStrHighMsg +
                      " Low : " + LastStrLowMsg + " Close : " + LastStrCloseMsg + " Volume : " + LastVolStrMsg);

                // LAST MSG - CRIA A MENSAGEM
                Msg = (" Last Candle = Ticks : " + LastTickStrCount + " Datetime : " + LastTickStrTime + " Open : " + LastStrOpenMsg + " High : " + LastStrHighMsg +
                       " Low : " + LastStrLowMsg + " Close : " + LastStrCloseMsg + " Volume : " + LastVolStrMsg);

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
        }// LAST- FIM DO IF CONTADOR TICKS ASK
    }// LAST - FECHA TIPO BARRA

    //------------------- CRIA O SERVIDOR SOCKET E ENVIA OS DADOS ARMAZENADOS EM Msg -------------------------------------------------------------------------------------+

    // SOCKET TRADE - RECEBE OS ORDENS DE COMPRA E VENDA DO PYTHON
    if (server != INVALID_SOCKET64)
    {
        char buf[1024] = {0};
        ref_sockaddr ref = {0};
        int len = ArraySize(ref.ref);
        int res = recvfrom(server, buf, 1024, 0, ref.ref, len);
        if (res >= 0)
        {
            string receive = CharArrayToString(buf);

            // SOCKET TRADE - DIVIDE A STRING RECEBIDA
            string sep = "_"; // SEPARADOR COMO CARACTERE
            ushort u_sep;     // CODIGO DO SEPARADOR
            string result[];  // ARRAY PARA OBTER STRINGS

            // SOCKET TRADE - CODIGO DO SEPARADOR
            u_sep = StringGetCharacter(sep, 0);

            // SOCKET TRADE - DIVIDE AS STRINGS EM SUBSTRINGS
            int k = StringSplit(receive, u_sep, result);
            string OpeTrade = result[1];
            string Lot = result[2];
            string TakeP = result[3];
            string StopL = result[4];

            Lote = (StringToDouble(Lot));
            TakeProfit = (StringToDouble(TakeP));
            StopLoss = (StringToDouble(StopL));

            // SOCKET TRADE - OPERACAO DE COMPRA
            if (OpeTrade == "buy")
            {
                trade.Buy(
                    Lote,          // TAMANHO DO LOTE
                    _Symbol,       // PEGA O SIMBOLO ATUAL
                    last_tick.ask, // PRECO LIMITE DE COMPRA
                    StopLoss,      // STOP LOSS
                    TakeProfit,    // TAKE PROFIT
                    NULL           // COMENTARIO
                );
            }

            // SOCKET TRADE - OPERACAO DE VENDA
            if (OpeTrade == "sell")
            {
                trade.Sell(
                    Lote,          // TAMANHO DO LOTE
                    _Symbol,       // PEGA O SIMBOLO ATUAL
                    last_tick.bid, // PRECO  DE VENDA
                    StopLoss,      // STOP LOSS
                    TakeProfit,    // TAKE PROFIT
                    NULL           // COMENTARIO
                );
            }

            // SOCKET TRADE - FECHA POSICAO
            if (OpeTrade == "close")
            {
                FechaPosicao();
            }

            // SOCKET MSG - ENVIA OS DADOS PARA O PYTHON 
            string respSend = Msg;
            uchar data[];
            StringToCharArray(respSend, data);

            // SOCKET ERRO - CASO NAO ENVIE OS DADOS PARA O PYTHON
            if (sendto(server, data, ArraySize(data), 0, ref.ref, ArraySize(ref.ref)) == SOCKET_ERROR)
            {
                // SOCKET ERRO - RECEBE O CODIGO DO ERRO E IMPRIME
                int err = WSAGetLastError();
                if (err != WSAEWOULDBLOCK)
                {
                    Print(" Falha no envio : " + WSAErrorDescript(err));
                    CloseClean();
                }
            }
            
            else
            {
                Msg = "";
            } // SOCKET MSG - FECHA SOCKET
           
        }// SOCKET TRADE - FECHA SOCKET
        
        else
        {
            // SOCKET ERRO - RECEBE O CODIGO DO ERRO E IMPRIME
            int err = WSAGetLastError();
            if (err != WSAEWOULDBLOCK)
            {
                Print("Falha no recebimento: " + WSAErrorDescript(err) + ". Limpar Socket");
                CloseClean();
                return;
            }
        }

    } // SOCKET TRADE - FECHA IF

    else
    {
        // SOCKET CONFIGS - CONFIG UDP WSADATA
        char wsaData[];
        ArrayResize(wsaData, sizeof(WSAData));
        int res = WSAStartup(MAKEWORD(2, 2), wsaData);

        // SOCKET ERRO - VERIFICA SE O PROBLEMA E WSAStartup
        if (res != 0)
        {
            Print(" Falha na inicializacao WSAStartup : " + string(res));
            return;
        }

        // SOCKET CONFIGS - UDP
        server = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);

        // SOCKET ERRO - VERIFICA SE O PROBLEMA E INVALID_SOCKET64
        if (server == INVALID_SOCKET64)
        {
            Print("Falha na criacao do Socket : " + WSAErrorDescript(WSAGetLastError()));
            CloseClean();
            return;
        }
        Print("Tentando Conectar..." + Host + ":" + string(Port));

        // SOCKET CONFIGS - PORT HOST
        char ch[];
        StringToCharArray(Host, ch);
        sockaddr_in addrin;
        addrin.sin_family = AF_INET;
        addrin.sin_addr.u.S_addr = inet_addr(ch);
        addrin.sin_port = htons(Port);
        ref_sockaddr ref;
        ref.in = addrin;

        // SOCKET ERRO - VERIFICA SE O PROBLEMA E SOCKET ERROR
        if (bind(server, ref.ref, sizeof(addrin)) == SOCKET_ERROR)
        {
            int err = WSAGetLastError();
            if (err != WSAEISCONN)
            {
                Print("Coneccao com Falha: " + WSAErrorDescript(err) + ". Cleanup socket");
                CloseClean();
                return;
            }
        }

        // SOCKET CONFIGS - DEFINI PARA O MODO SEM BLOQUEIO
        int non_block = 1;
        res = ioctlsocket(server, (int)FIONBIO, non_block);

        // SOCKET ERRO - VERIFICA SE O PROBLEMA E ioctlsocket
        if (res != NO_ERROR)
        {
            Print("Falha erro no ioctlsocket : " + string(res));
            CloseClean();
            return;
        }
        Print("Start Server ok");

    } // FECHA IF DA VERIFICACAO DO SERVER UDP

} // FECHA IF ONTICK

//+------------------------------------------------------------------+
//|                         FECHA-POSICAO                            |
//+------------------------------------------------------------------+
void FechaPosicao()
{
    for (int i = PositionsTotal() - 1; i >= 0; i--) // CONTADOR
    {
        ulong Positionticket = PositionGetTicket(i); // PEGA O NUMERO DE TICKETS NA POSICAO ATUAL
        trade.PositionClose(Positionticket);         // FECHA TODAS AS POSICOES ABERTAS
    }

} // FECHA IF DA FUNCAO FECHA POSICAO

//+------------------------------------------------------------------+
//|                         ON-DEINIT                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    EventKillTimer();
    CloseClean();
}

//+------------------------------------------------------------------+
//|                        CLOSE-CLEAN                               |
//+------------------------------------------------------------------+
void CloseClean()
{
    // SOCKET - FECHA SERVIDOR SOCKET
    Print(" Desliga Servidor Socket ");
    if (server != INVALID_SOCKET64)
    {
        closesocket(server);
        server = INVALID_SOCKET64;
    }
    WSACleanup();
}
