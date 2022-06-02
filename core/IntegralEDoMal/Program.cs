namespace Calculo2TP1
{
  class Program
  {

    static void Main(string[] args)
    {
      Console.WriteLine("Hello, World!");
      CaucularIntegral("2x", "(x - 1)(x - 2)(x - 4)");
      CaucularIntegral("3x", "(x + 1)(x + 2)", 1, 0);
      CaucularIntegral("1", "(x + 3)(x - 2)(x + 4)");
      CaucularIntegral("2x", "x² - 5x + 6");
      CaucularIntegral("7x", "(x + 3)(x + 2)");
      CaucularIntegral("3x", "x² - 10x + 21");
      CaucularIntegral("1", "x² - 4");

    }

    static void CaucularIntegral(string cima, string baixo, int sup = 0, int inf = 0)
    {
      cima += " ";
      List<string> lbaixo;
      List<Num> embaixo;

      if (baixo[0] != '(')
      {
        baixo += " ";
        //calcular baskara
        lbaixo = ExtrairPalavra(baixo);

        embaixo = InserirSegundoGrau(lbaixo);

        embaixo = SegundoGrau(embaixo);
      }
      else
      {
        lbaixo = ExtrairPalavra(baixo);

        embaixo = InserirNum(lbaixo);
      }

      var lcima = ExtrairPalavra(cima);
      var emcima = InserirNum(lcima)[0];

      var abc = CalculaABC(emcima, embaixo);

      if (sup != 0 || inf != 0)
      {
        Console.WriteLine(CalculaIntegralImpropria(embaixo, abc, sup, inf));
      }
      else
      {
        ImprimirIntegral(embaixo, abc);
      }
    }
    static void ImprimirIntegral(List<Num> baixo, List<double> abc)
    {
      var numx = "";
      var imprimirTudo = "";
      for (int i = 0; i < baixo.Count; i++)
      {
        if (baixo[i].Numx == 1)
        {
          numx = "x";
        }
        else
        {
          numx = baixo[i].Numx + "x";
        }
        imprimirTudo += ColocaSinal(abc[i]) + "ln(" + numx + " " + ColocaSinal(baixo[i].NumSx) + ") ";
      }
      Console.WriteLine(imprimirTudo + "+ C");
    }

    static string ColocaSinal(double num)
    {
      if (num > 0)
      {
        return "+ " + num;
      }
      else
      {
        return "- " + num * -1;
      }
    }

    static List<double> CalculaABC(Num cima, List<Num> baixo)
    {
      var respostas = new List<double>();
      for (int i = 0; i < baixo.Count; i++)
      {
        var numatual = -1 * baixo[i].NumSx / baixo[i].Numx;
        var soma = 0.0;
        for (int j = 0; j < baixo.Count; j++)
        {
          if (i != j)
          {
            soma += baixo[j].Numx * numatual + baixo[j].NumSx;
          }
        }
        var calculo = (cima.NumSx + cima.Numx * numatual) / soma;
        respostas.Add(calculo);
      }

      return respostas;
    }

    static double CalculaIntegralImpropria(List<Num> baixo, List<double> abc, int sup, int inf)
    {
      //terminar
      var soma = 0.00;
      for (int i = 0; i < baixo.Count; i++)
      {
        soma += abc[i] * Math.Log(baixo[i].Numx * (double)sup + baixo[i].NumSx);
        soma -= abc[i] * Math.Log(baixo[i].Numx * (double)inf + baixo[i].NumSx);
      }

      return soma;
    }

    static Tuple<Num, Num> CalculaBaskara(List<Num> baixo)
    {
      var primeiro = new Num();
      var segundo = new Num();

      var delta = Math.Pow(baixo[1].Numx, 2) - 4 * baixo[0].Numx * baixo[2].NumSx;
      var baskaraPosi = (-1 * baixo[1].Numx + Math.Sqrt(delta)) / 2 * baixo[0].Numx;
      var baskaraNega = (-1 * baixo[1].Numx - Math.Sqrt(delta)) / 2 * baixo[0].Numx;

      primeiro.Numx = baixo[0].Numx;
      segundo.Numx = baixo[0].Numx; ;

      primeiro.NumSx = baskaraPosi * -1 * baixo[0].Numx;

      segundo.NumSx = baskaraNega * -1 * baixo[0].Numx;
      return new Tuple<Num, Num>(primeiro, segundo);
    }
    static Tuple<Num, Num> SegundoIncompleta(List<Num> baixo)
    {
      var primeiro = new Num();
      var segundo = new Num();
      primeiro.Numx = baixo[0].Numx;
      segundo.Numx = baixo[0].Numx;

      if (baixo[1].NumSx < 0)
      {
        baixo[1].NumSx *= -1;

        primeiro.NumSx = Math.Sqrt(baixo[1].NumSx);
        segundo.NumSx = primeiro.NumSx * -1;
      }
      else
      {
        primeiro.Numx = Math.Sqrt(baixo[1].Numx);
        segundo.NumSx = primeiro.NumSx;
      }

      return new Tuple<Num, Num>(primeiro, segundo);
    }
    static List<Num> SegundoGrau(List<Num> baixo)
    {
      var respostas = new List<Num>();

      //so calcula se tiver 3 cara
      //fazer com so 2
      if (baixo.Count == 3)
      {
        var baskara = CalculaBaskara(baixo);
        respostas.Add(baskara.Item1);
        respostas.Add(baskara.Item2);
      }
      else if (baixo.Count == 2)
      {
        var segundoIncompleta = SegundoIncompleta(baixo);
        respostas.Add(segundoIncompleta.Item1);
        respostas.Add(segundoIncompleta.Item2);
      }

      return respostas;
    }

    static List<Num> InserirNum(List<string> baixo)
    {
      var lista = new List<Num>();
      for (int i = 0; i < baixo.Count; i += 1)
      {
        var num = new Num();
        if (baixo[i].Contains("x") == true)
        {
          baixo[i] = baixo[i].Replace("²", "");

          if (baixo[i] == "x")
          {
            num.Numx = 1;
          }
          else
          {
            baixo[i] = baixo[i].Replace("x", "");
            num.Numx = Convert.ToDouble(baixo[i]);
          }
          if (baixo.Count != 1)
          {
            num.NumSx = Convert.ToDouble(baixo[i + 1]);
            i++;
          }
        }
        else
        {
          num.Numx = 0;
          num.NumSx = Convert.ToDouble(baixo[i]);
        }

        lista.Add(num);
      }

      return lista;
    }
    static List<Num> InserirSegundoGrau(List<string> baixo)
    {
      var lista = new List<Num>();
      for (int i = 0; i < baixo.Count; i += 1)
      {
        var num = new Num();
        if (baixo[i].Contains("x") == true)
        {
          baixo[i] = baixo[i].Replace("²", "");

          if (baixo[i] == "x")
          {
            num.Numx = 1;
          }
          else
          {
            baixo[i] = baixo[i].Replace("x", "");
            num.Numx = Convert.ToDouble(baixo[i]);
          }
          // if (baixo.Count != 1)
          // {
          //   num.NumSx = Convert.ToDouble(baixo[i + 1]);
          //   i++;
          // }
        }
        else
        {
          num.Numx = 0;
          num.NumSx = Convert.ToDouble(baixo[i]);
        }

        lista.Add(num);
      }

      return lista;
    }

    public static List<string> ExtrairPalavra(string palavras)
    {
      var palavra = String.Empty;

      var listapalavras = new List<string>();
      palavras = palavras.Replace(" + ", " ");
      palavras = palavras.Replace(" - ", " -");
      palavras = palavras.Replace("(", "");
      palavras = palavras.Replace(")", " ");
      var tamanho = palavras.Length;
      for (int i = 0; i < tamanho; i++)
      {
        if (palavras[i] != ' ')
        {
          palavra += palavras[i];
        }
        else
        {
          listapalavras.Add(palavra);
          palavra = String.Empty;
        }

      }

      return listapalavras;
    }

  }
}