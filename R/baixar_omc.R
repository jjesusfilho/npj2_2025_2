

urls <- glue::glue("https://docs.wto.org/dol2fe/Pages/SS/directdoc.aspx?filename=Q:/G/L/{1:1585}.pdf&Open=True")


purrr::iwalk(urls, ~{

  arquivo <- glue::glue(here::here("omc/consultas/documento_{.y}.pdf"))



  .x |>
    httr2::request() |>
    httr2::req_perform(path = arquivo)


})








urls <- glue::glue("https://www.wto.org/english/tratop_e/dispu_e/cases_e/ds{1:1000}_e.htm")


purrr::iwalk(urls, ~{

  arquivo <- glue::glue(here::here("omc/htmls/ds_{.y}.html"))



  .x |>
    httr2::request() |>
    httr2::req_perform(path = arquivo)


})



a1 <- JurisMiner::listar_arquivos("omc/consultas")

a2 <- JurisMiner::listar_arquivos("omc/htmls")


consultas <- JurisMiner::ler_pdfs(a1)

consultas <- consultas |>
  mutate(documento = str_extract(arquivo, "\\d+"))


consultas <- consultas |>
   group_by(documento) |>
     mutate(pagina = row_number() )

consultas <- consultas |>
     mutate(codigo = case_when(
       pagina == 1 ~ str_extract(texto, "\\w+/\\X+?(Page")

     ))


consultas <- consultas |>
     mutate(codigo2 = str_trim(codigo) |> str_extract("\\X+?(?=\\d{1,2}\\s\\p{L}+\\s\\d{4}\\b)"))



consultas <- consultas |>
        mutate(ds = str_detect(codigo2, "DS"),
               g_l = str_detect(codigo2, "G/L"))


s <- consultas |>
      filter(pagina == 1)

s <- s |>
      stringr::str_extract()


lista <- JurisMiner::listar_arquivos("omc/gpt")

gpt <- JurisMiner::gpt_ler(lista, colunas)



gpt <- gpt |>
   chop(países)


gpt <- gpt |>
  mutate(grupo = ntile(n = 6), .before = 1)
gpt <- gpt |>
  mutate(países = map(países, ~paste(.x, collapse = "; ")) |> unlist())

writexl::write_xlsx(gpt, "data/gpt.xlsx")

pasta <- "https://drive.google.com/drive/folders/1AzqGg7TG0rCKs_npHRBad9nynqwpEisi"

library(googledrive)
drive_auth("jose@consudata.com.br")



gpt <- gpt |>
    mutate(documento = str_extract(nome_arquivo, "\\d+"))


gpt <- gpt |>
   mutate(link = glue::glue("https://docs.wto.org/dol2fe/Pages/SS/directdoc.aspx?filename=Q:/G/L/{documento}.pdf&Open=True") |> as.character())

gpt$nome_arquivo <- NULL


JurisMiner::hyperlink_excel(gpt, col_link = link, col_texto = documento, arquivo = "data/gpt.xlsx")

writexl::write_xlsx(gpt,"data/gpt.xlsx")

drive_put("data/gpt.xlsx", as_id(pasta))



