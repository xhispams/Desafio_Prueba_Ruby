require 'uri'
require 'net/http'
require 'openssl'
require 'json'

def request(address,api_key)

	url = URI(address+api_key)
	http = Net::HTTP.new(url.host, url.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Get.new(url)
	request["cache-control"] = 'no-cache'
	request["Postman-Token"] = '8217966f-0d97-4c9c-a071-bb892ac8f82b'

	response = http.request(request)
	return JSON.parse response.read_body
end

def build_web_page(datos,n_fotos)
    html_inicio = '<html>
    <head>
    </head>
    <body>
    <ul>
    '

    html_fin = '<ul>
    </body>
    </html>
    '
	datos_filtrado = []
	100.times do |x| 
		datos_filtrado << datos['photos'][x]['img_src']
	end

	html = ""

	datos_filtrado.each do |photo|
		html += "\t<li><img src=\"#{photo}\" height=\"400px\"></li>\n"
	end

	pagina = html_inicio+html+html_fin
	File.write('index_nasa.html', pagina)
	return pagina
end

def photos_count(datos)

	camaras = {
	'FHAZ' => 0,
	'NAVCAM' => 0,
	'MAST' => 0,
	'CHEMCAM' => 0,
	'MAHLI' => 0,
	'MARDI' => 0,
	'RHAZ' => 0,
	'MINITES' => 0,
	'PANCAM' => 0
	}

	datos['photos'].each do |x|
	valor = x["camera"]["name"]
	camaras[valor] += 1
	end

	puts camaras
	return camaras
end

direccion_api = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key="
clave_api = "ASBuaPP6wPeQVKo0iukRhwXvCWSX4Y7nJOFPJrtS"
numero_fotos = 1000

datos = request(direccion_api,clave_api) #parte1

pagina = build_web_page(datos,numero_fotos) #parte2

camaras = photos_count(datos) #parte3, cuenta la totalidad de las fotos