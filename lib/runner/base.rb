require 'optparse'
require 'version'
require 'wsfeClient.rb'

module WSFE
  module Runner
    class Base

      OPTIONS = {
        :cuit      => ["-c", "--cuit CUIT",    "Cuit del contribuyente."],
        :ticket    => ["-t", "--ticket TICKET","Ubicación del ticket de acceso. Si existe y",
                                               "el ticket aún es válido, se utilizará para",
                                               "la comunicación con el WSFE. En caso contrario",
                                               "se solicitará un nuevo ticket y se almacenará",
                                               "en la ubicación especificada.",
                                               "Valor por defecto: ./<cuit>.xml"],
        :cert      => ["-r", "--cert CERT",    "Ubicación del certificado digital provisto por AFIP.",
                                               "Valor por defecto: ./<cuit>.crt"],
        :key       => ["-k", "--key KEY",      "Ubicación de la clave privada que se utilizará para",
                                               "firmar las solicitudes.",
                                               "Valor por defecto: ./<cuit>.key"],
        :out       => ["-o", "--out PATH",     "Guarda la respuesta en el archivo indicado (opcional)"],
        :xml       => ["-x", "--xml PATH",     "Guarda el xml devuelto por AFIP en el archivo indicado,",
                                               "antes de procesarlo (opcional)."],
        :servicios => ["-s", "--servicios",    "Indica que lo que se está facturando corresponde",
                                               "a prestación de servicios (opcional)."],
        :test      => ["-e", "--test",         "Ejecuta el servicio en el entorno de pruebas de AFIP."],
        :info      => ["-i", "--info",         "Muestra información de ayuda acerca para el servicio especificado."],
        :version   => ["-v", "--version",      "Informa la versión actual del script."]
      }

      attr_reader :options, :parser

      def initialize
        super
        @options = WSFE::Runner::Options.new
      end

      def run(argv)
        load_options(argv)
        main
      end

      def load_options(argv)
        ::OptionParser.new { |p| @parser = p ; parse_options }
        #@options = parser.order!(argv)
        begin
          parser.parse!(argv)
        rescue OptionParser::InvalidOption => e
          error_exit(e)
        end
      end

      def main
      end

      def parse_options
      end

      def parse_authentication_options
        parser.on(*OPTIONS[:cuit])   { |cuit|   @options.cuit = cuit unless cuit.empty? }
        parser.on(*OPTIONS[:ticket]) { |ticket| @options.ticket = ticket unless ticket.empty? }
        parser.on(*OPTIONS[:cert])   { |cert|   @options.cert = cert unless cert.empty? }
        parser.on(*OPTIONS[:key])    { |key|    @options.key = key unless key.empty? }
      end

      def parse_common_options
        parser.on(*OPTIONS[:out])          { |out| @options.out = out }
        parser.on_tail(*OPTIONS[:test])    { @options.test = true }
        parser.on_tail(*OPTIONS[:version]) { version_exit }
        parser.on_tail(*OPTIONS[:info])    { info_exit }
      end

      def version_exit
        puts WSFE::VERSION::DESCRIPTION
        exit 1
      end

      def info_exit
        puts parser, "\n", descripcion
        exit 1
      end      

      def error_exit(msg)
        puts parser, "\n", descripcion, "\n", msg
        exit 1
      end

      def obtieneTicket
        cert_file = @options.cert
        key_file = @options.key
        ticket = WSAA::Ticket.load(cuit, @options.ticket) if @options.ticket
        ticket = WSAA::Client.requestTicket(@options.cuit, 'wsfe', cert_file, key_file) if ticket.nil? || ticket.invalid?
        ticket.save(@options.ticket) if ticket && ticket.valid? && @options.ticket
        ticket
      end
      
      def descripcion
      end

      def self.run(argv)
        new.run(argv)
      end
    end
  end
end