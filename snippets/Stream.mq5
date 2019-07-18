
class StreamPack : public IStream
{
   IStream *_main;
   IStream *_secondary[];
public:
   StreamPack(IStream *main)
   {
      _main = main;
   }

   ~StreamPack()
   {
      delete _main;
      int count = ArrayRange(_secondary, 0);
      for (int i = 0; i < count; ++i)
      {
         delete _secondary[i];
      }
   }

   void Add(IStream *stream)
   {
      int count = ArrayRange(_secondary, 0);
      ArrayResize(_secondary, count + 1);
      _secondary[count] = stream;
   }

   virtual bool GetValues(const int period, const int count, double &val[])
   {
      return _main.GetValues(period, count, val);
   }

   virtual int Size()
   {
      return _main.Size();
   }
};

class LowestPriceStream : public AStream
{
   int _periods;
public:
   LowestPriceStream(InstrumentInfo *symbolInfo, const ENUM_TIMEFRAMES timeframe, int periods)
      :AStream(symbolInfo, timeframe)
   {
      _periods = periods;
   }

   virtual bool GetValues(const int period, const int count, double &val[])
   {
      string symbol = _symbolInfo.GetSymbol();
      for (int i = 0; i < count; ++i)
      {
         val[i] = (double)iLowest(symbol, _timeframe, MODE_LOW, _periods, period);
      }
      return true;
   }
};

class HighestPriceStream : public AStream
{
   int _periods;
public:
   HighestPriceStream(InstrumentInfo *symbolInfo, const ENUM_TIMEFRAMES timeframe, int periods)
      :AStream(symbolInfo, timeframe)
   {
      _periods = periods;
   }

   virtual bool GetValues(const int period, const int count, double &val[])
   {
      string symbol = _symbolInfo.GetSymbol();
      for (int i = 0; i < count; ++i)
      {
         val[i] = (double)iHighest(symbol, _timeframe, MODE_HIGH, _periods, period);
      }
      return true;
   }
};