namespace Calculo2TP1
{
  class Program
  {

    static void Main(string[] args)
    {
      Console.WriteLine("Hello, World!");
      Inserir("3x", "(x + 1)(x + 2)");
    }

    static void Inserir(string cima, string baixo)
    {
      if (baixo[0] != '(')
      {

      }

      var lcima = ExtrairPalavra(cima);
      var lbaixo = ExtrairPalavra(baixo);


    }

    public static List<string> ExtrairPalavra(string palavras)
    {
      var palavra = String.Empty;
      var tamanho = palavras.Length;

      var listapalavras = new List<string>();
      palavra.Replace(" + ", " ");
      palavra.Replace(" - ", " -");
      palavra.Replace("(", "");
      palavra.Replace(")", " ");
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

      listapalavras.Add(palavra);

      return listapalavras;
    }

  }
}