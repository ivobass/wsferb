#
# Web Services Facturacion Electronica AFIP
# Copyright (C) 2008-2011 Matias Alejandro Flores <mflores@atlanware.com>
#
module WSFErb
  module WSFE
    class Response::FEParamGetTiposDoc < Response
      def format_record(record)
        "1%02d%-8s%-8s%-250s" % [ record[:id],
                                  record[:fch_desde],
                                  record[:fch_hasta],
                                  record[:desc] ]
      end

      def records
        @records ||= [result[:result_get][:doc_tipo]].flatten rescue []
      end

      def result
        @result ||= response[:fe_param_get_tipos_doc_response][:fe_param_get_tipos_doc_result] rescue []
      end
    end
  end
end
