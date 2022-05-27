namespace Calculo2TP1
{
  class Program
  {

    static void Main(string[] args)
    {
      Console.WriteLine("Hello, World!");
      CaucularIntegral("2x", "(x - 1)(x - 2)(x - 4)");
    }

    static void CaucularIntegral(string cima, string baixo, uint? sup = null, uint? inf = null)
    {
      cima += " ";
      if (baixo[0] != '(')
      {
        //calcular baskara
      }

      var lcima = ExtrairPalavra(cima);
      var lbaixo = ExtrairPalavra(baixo);
      var emcima = InserirNum(lcima)[0];
      var embaixo = InserirNum(lbaixo);

      var abc = CalculaABC(emcima, embaixo);
      ImprimirIntegral(embaixo, abc);
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
        var numatual = -1 * baixo[i].NumSx;
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

    static List<Num> InserirNum(List<string> baixo)
    {
      var lista = new List<Num>();
      for (int i = 0; i < baixo.Count; i += 1)
      {
        var num = new Num();
        if (baixo[i].Contains("x") == true)
        {
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