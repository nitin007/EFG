# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

if ENV['EFG_HOST'] == 'www.sflg.gov.uk'
  require 'verde_transfer'

  old_lender = Lender.find(19)
  new_lender = Lender.find(39)

  loans = [
    '103772',
    '8P2DNHC+01',
    'P3GZ5L3+01',
    'HUJRPED+01',
    '5JR5P7S+01',
    'DX28JGU+01',
    'T99VCSS+01',
    'NULKIUD-01',
    'CB7IVQ3-01',
    'MDF8J6X+01',
    '8V6XKDT+01',
    'A4TQ6TD+01',
    '4ECDMZD-01',
    'P5EWBU4+01',
    'P67MP62+01',
    '46UB7WG+01',
    '7LSMHW1-01',
    'SX9VNUA+01',
    'SMT2JMU+01',
    'RJC6UJ4+01',
    '25ZDAUX+01',
    'MBQFNNZ+01',
    'QRRFC2L+01',
    'N6NLJHB+01',
    'BCEXL2C+01',
    '6FPU7NE+01',
    'RAQ8VYZ+01',
    '5ZCGETP+01',
    'QQP5REU+01',
  ].map { |reference|
    old_lender.loans.where(reference: reference).first!
  }

  VerdeTransfer.run(loans, new_lender)
end
