#
# Web Services Facturacion Electronica AFIP
# Copyright (C) 2008-2011 Matias Alejandro Flores <mflores@atlanware.com>
#
module WSFErb
  module WSFE
    class Response::FEParamGetTiposIva < Response::FEParam
      def format_record(record)
        "%02d%-250s%-8s%-8s" % [ record[:id],
                                 record[:desc],
                                 record[:fch_desde],
                                 record[:fch_hasta] ]
      end

      def records
        @records ||= result[:result_get][:iva_tipo] rescue []
      end

      def result
        @result ||= response[:fe_param_get_tipos_iva_response][:fe_param_get_tipos_iva_result] rescue []
      end
    end
  end
end
