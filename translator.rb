require 'rest-client'
require 'json'
require 'fileutils'

class Translator
  def self.translate(text, source_lang, target_lang)
    url = "https://api.mymemory.translated.net/get"
    params = {
      'q' => text,
      'langpair' => "#{source_lang}|#{target_lang}" 
    }

    begin
      response = RestClient.get(BASE_URL, params: params)
      translation = JSON.parse(response.body)["responseData"]["translatedText"]
    rescue RestClient::ExceptionWithResponse => e
      puts "Erro na solicitação HTTP: #{e.response}"
      return nil
    rescue JSON::ParserError => e
      puts "Erro ao analisar a resposta JSON: #{e.message}"
      return nil
    end

    translation
  end
end

puts "Bem-vindo ao RubyTradutor!"

puts "Idioma original(en, pt, es, fr...): "
source_lang = gets.chomp

puts "Idioma para tradução(en, pt, es, fr...): "
target_lang = gets.chomp

puts "Digite aqui o texto que deseja traduzir: "
original_text = gets.chomp

translated_text = Translator.translate(original_text, source_lang, target_lang)

puts "Tradução: #{translated_text}"

base_path = "Ruby-Translate/translations"

FileUtils.mkdir_p(base_path) unless File.directory?(base_path)

timestamp = Time.now.strftime("%d-%m-%Y_%H-%M-%S")
filename = "#{base_path}/#{timestamp}.txt"

File.open(filename, 'w') do |file|
  file.puts("Texto Original:\n  #{original_text}")
  file.puts("\nTexto Traduzido:\n  #{translated_text}")
end

puts "Sua tradução foi salva em: #{filename}"