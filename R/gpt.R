#!/usr/bin/env Rscript

perguntas <- c("Lembrando que este é um documento da OMC. Faça um resumo do texto",
               "Que tipo de documento é este? Leve em conta pedidos anteriores de classificação de documentos da OMC para classficiar melhor",
               "Trata-se de uma documento sobre disputa? responda sim ou não",
               "Que países estão envolvidos no caso?",
               "Quem peticionou?",
               "Quais temas são objeto do conflito? agricultura, restrições quantitativas, têxteis, bens industriais, tarifas, acesso a mercado, salvaguardas, serviços, antiduping e subsídios, meio ambinte. Separe-os por ponto e vírgula")


colunas <- c("resumo","tipo","disputa","países","peticionario","temas")

arquivos <- JurisMiner::listar_arquivos(here::here("omc/consultas"))
consultas <- JurisMiner::ler_pdfs(arquivos)

consultas <- consultas |>
     dplyr::mutate(resposta = stringr::str_replace(arquivo, ".pdf", ".json"))


baixados <- JurisMiner::listar_arquivos(here::here("omc/gpt")) |>
             basename() |>
            tibble::tibble(resposta = _)


consultas <- consultas |>
        dplyr::anti_join(baixados)

purrr::walk2(consultas$texto, consultas$resposta, ~{



  JurisMiner::gpt_extrair(.x, perguntas = perguntas, chaves = colunas, modelo = "gpt-5-nano",
                          temperatura = 1) |>
    write(here::here(paste0("omc/gpt/",.y)))


})



