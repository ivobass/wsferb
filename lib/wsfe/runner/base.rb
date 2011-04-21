#
# Web Services Facturacion Electronica AFIP
# Copyright (C) 2008-2011 Matias Alejandro Flores <mflores@atlanware.com>
#
require 'optparse'
require 'options'

module WSFE
  module Runner
    class Base

      OPTIONS = {
        :cuit      => ["-c", "--cuit CUIT",    "Cuit del contribuyente."],
        :ticket    => ["-t", "--ticket TICKET","Ubicacion del ticket de acceso. Si existe y",
                                               "el ticket aun es valido, se utilizara para",
                                               "la comunicacion con el WSFE. En caso contrario",
                                               "se solicitara un nuevo ticket y se almacenara",
                                               "en la ubicacion especificada.",
                                               "Valor por defecto: ./<cuit>.xml"],
        :cert      => ["-r", "--cert CERT",    "Ubicacion del certificado digital provisto por AFIP.",
                                               "Valor por defecto: ./<cuit>.crt"],
        :key       => ["-k", "--key KEY",      "Ubicacion de la clave privada que se utilizara para",
                                               "firmar las solicitudes.",
                                               "Valor por defecto: ./<cuit>.key"],
        :out       => ["-o", "--out PATH",     "Guarda la respuesta en el archivo indicado (opcional)"],
        :log       => ["-l", "--log PATH",     "Guarda un log de la transaccion en el archivo indicado,",
                                               "incluyendo el xml devuelto por AFIP (opcional)."],
        :id        => ["-d", "--id ID",        "Numero identificador de la transaccion."],
        :servicios => ["-s", "--servicios",    "Indica que lo que se esta facturando corresponde",
                                               "a prestacion de servicios (opcional)."],
        :test      => ["-e", "--test",         "Ejecuta el servicio en el entorno de pruebas de AFIP."],
        :help      => ["-h", "--help",         "Muestra informacion de ayuda acerca del servicio especificado."],
        :version   => ["-v", "--version",      "Informa la version actual del script."]
      }

      attr_reader :options, :parser

      def initialize
        super
        @options = WSFErb::Options.new
      end

      def run(argv)
        load_options(argv)
        begin
          r = main
        rescue RuntimeError => e
          puts e.message
        end
        if @options.out 
          File.open(@options.out, 'w') { |f| f.puts(r) } 
        else
          puts r
        end
      end

      def load_options(argv)
        OptionParser.new { |p| @parser = p ; parse_options }
        begin
          parser.parse!(argv)
        rescue OptionParser::InvalidOption => e
          info_exit
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
        parser.on(*OPTIONS[:log])          { |log| Savon.log, Savon.logger = true, Logger.new(log) }
        parser.on_tail(*OPTIONS[:test])    { Client.enable_test_mode ; WSAA::Client.enable_test_mode }
        parser.on_tail(*OPTIONS[:version]) { version_exit }
        parser.on_tail(*OPTIONS[:help])    { info_exit }
      end

      def parse_other_options
        parser.on(*OPTIONS[:id])        { |id| @options.id = id }
        parser.on(*OPTIONS[:servicios]) { @options.servicios = true }
      end

      def version_exit
        puts Version::DESCRIPTION
        exit 1
      end

      def info_exit
        puts parser, "\n", descripcion, "\n"
        exit 1
      end      

      def error_exit(msg=nil)
        puts parser, "\n", descripcion, "\n"
        puts "Error: #{msg}" unless msg.nil?
        exit 1
      end

      alias_method :error, :error_exit

      def ticket
        cert_file = @options.cert
        key_file = @options.key
        ticket = WSAA::Ticket.load(@options.cuit, @options.ticket) if @options.ticket
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
