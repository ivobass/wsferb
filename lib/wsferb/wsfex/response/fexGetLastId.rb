# Web Services Facturacion Electronica AFIP
# Copyright (C) 2008-2011 Matias Alejandro Flores <mflores@atlanware.com>
#
module WSFEX
  class Response::FEXGetLastId < Response
    def value
      result[:fex_result_get][:id] rescue "n/d"
    end

    def result
      response[:fex_get_last_id_response][:fex_get_last_id_result] rescue {}
    end
  end
end