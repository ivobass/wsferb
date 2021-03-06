.. index:: FEXGetLastId

FEXGetLastId
============

Devuelve el identificador único del último requerimiento enviado a :doc:`fexAuthorize`.

Modo de uso
-----------

::

  wsfex FEXGetLastId <opciones>

Opciones
~~~~~~~~

.. include:: _options.inc

Respuesta
---------

.. include:: _response_format.inc

Tipo de Registro 1
~~~~~~~~~~~~~~~~~~

La respuesta contiene un registro de tipo "1" con el identificador del último requerimiento enviado a :doc:`fexAuthorize`.

==================== ======= ==================================================
Campo                Tipo    Descripción
==================== ======= ==================================================
TipoReg              S(1)    Tipo de Registro - "1"
Id                   N(15)   Ultimo ID utilizado
==================== ======= ==================================================

.. include:: _errors.inc
.. include:: _events.inc

Errores Posibles
~~~~~~~~~~~~~~~~

Este servicio puede devolver los siguientes códigos de error:

.. include:: _wsfex_common_errors.inc
