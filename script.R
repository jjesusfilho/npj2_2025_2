

numeros <- JurisMiner::cnj_sequencial(1,1000, 2025, 8, 26, 100)


tjsp::tjsp_autenticar(email_provider = "gmail")


tjsp::tjsp_baixar_cpopg(sample(numeros, 100), diretorio = "cpopg")


arquivos <- JurisMiner::listar_arquivos("cpopg")

partes <- tjsp::tjsp_ler_partes(arquivos)

dados <- tjsp::tjsp_ler_dados_cpopg(arquivos)



tjsp::tjsp_baixar_cjpg(assunto = '4654,10499,4656,50924,4660,4670,4680,50922',
                       diretorio = "cjpg",
                       paginas = 1:100)

cjpg <- tjsp::tjsp_ler_cjpg(diretorio ="cjpg")

