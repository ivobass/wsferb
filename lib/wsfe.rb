#
# Web Services Facturacion Electronica AFIP
# Copyright (C) 2008-2011 Matias Alejandro Flores <mflores@atlanware.com>
#
require 'wsfe/client'
require 'wsfe/response'
require 'wsfe/runner'
require "version"

module WSFE
  include Version

  SERVICES = %w(FEAutRequest
                FEUltNroRequest
                FERecuperaQTYRequest
                FERecuperaLastCMPRequest
                FEConsultaCAERequest
                FEDummy)
end
