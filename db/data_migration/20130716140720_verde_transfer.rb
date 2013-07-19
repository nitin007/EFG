# This is intended to provide a mechanism by which relatively expensive data
# updates can be decoupled from deployment time and run independently.
#
# This will execute within an ActiveRecord transaction and is instance_eval-ed.
# Just write normal ruby code and refer to any model objects that you require.
# Since a data migration is intended to be run in production, when the schema
# and model are known quantities, it should be fine to reference model classes
# directly, even though in the future they may be refactored or deleted
# entirely.

require 'verde_transfer'

old_lender = Lender.find(19)
new_lender = Lender.find(39)
loan_references = [
  'WR8VYS4+01', 'DSDR3EM+01', 'UAAGP56+01', '53HRMV6+01', 'EBGJ6WU-01',
  'RS54SVL+01', 'XN9W34X+01', 'TGD5ESG+01', 'ZD7YVTH+01', 'VBKSFTW+01',
  'L3G8KDJ+01', 'G7SDQ2L+01', '111617', 'KTNSDJE+01', 'ANGL3DV+01',
  '2UUBU4A+01', 'N6NLJHB+01', '4XX7FD5+01', 'YESA99S+01', 'XDUM5AG-01',
  'T99VCSS+01', '82Y9CZE+01', '2X2YTVP+01', '6J7SYNW-01', '7H49DX7+01',
  '6NUC25W+01', 'ZZTG2KL+01', '46UB7WG+01', 'J4UK7MC+01', 'T78W57Q+01',
  'RAQ8VYZ+01', 'Z9Y9NST+01', 'F8PAWH3+01', 'W7DNNRQ+01', '46N7Y3A+01',
  'UVL9BXB+01', 'QK7ATX2+01', 'JFTEDSH+01', '5JR5P7S+01', 'S8HV3FR+01',
  '106940', 'YQR9XSC+01', '9WSTKSE+01', 'LGYYVHE+01', 'TL9J2K8+01',
  '6UXGUX4+01', 'ZT4TNBV+01', 'NDHZ29V+01', '5GVDJXX+01', 'K9L9GG6+01',
  'A7TL2DC+01', '102367', '3KZDZC6+01', 'TW2BHD9+01', 'MFBGGW5+01',
  '9EYB5SZ+01', 'Y9K227H+01', 'W3AE8PH+01', 'Z8AMNFW+01', 'U8H6UEU-01',
  'Y3N59Q4-01', 'BCEXL2C+01', 'W8XHWTN+01', 'RCAECZF+01', 'WHWTF6Q+01',
  'D3TBT8A+01', 'YLMVQVL+01', 'X9A2BTG+01', '8PAHNKH+01', '9NEULPC+01',
  'DX28JGU+01', 'SBCPN8P+01', 'ASL6E6Y+01', '93531', '52WRTXU+01', '111162',
  'LTRYP9Z+01', '9NF2ZWU+01', '245B6FG+01', 'AWA784Y+01', 'P3GZ5L3+01',
  'R4MLJRR+01', 'WA4TKJ7+01', 'MDF8J6X+01', 'P5EWBU4+01', '46PR2WT-01',
  '8V6XKDT+01', '4ECDMZD-01', 'VF87ZCL+01', 'PUZU8NZ+01', 'JK7X77R+01',
  'UM3L59B+01', '5TTZGRK+01', 'WYBFGTD+01', '8LR0BS8-01', 'A4TQ6TD+01',
  'TDJEGD8+01', 'P67MP62+01', 'MBQFNNZ+01', 'RY3D7YL-01', 'Y84A6JL+01',
  'SX9VNUA+01', 'VGJB2CX+01', 'NTGB93W+01', 'VZAZ64V+01', 'GM7GLQW+01',
  'KGHHZBA+01', 'TLZTE24-01', 'MGRZJ5K+01', '109338', '110535', '108853',
  'QRQUSLH-01', 'Q67M6B5+01', 'NULKIUD-01', 'CB7IVQ3-01', 'TXP4QMZ+01',
  'FZSQUXZ+01', 'X7MMPDN+01', 'TVX48FU-01', 'CS9BNWV+01', '8ZHSUZE-01',
  'H4V3ZSV-01', 'QQP5REU+01', 'BHJ9C3Z+01', '7LSMHW1-01', '106808',
  'C4PJZFD+01', 'GMHMHHB+01', 'C88EHKZ+01', '93780', 'W4Z4KHH+01',
  'R9B65ZE+01', 'KBXK5QG+01', 'HUJRPED+01', 'QRRFC2L+01', '103604', '106966',
  'KRD6JN9+01', 'CC7A95J+01', 'RJC6UJ4+01', '2RH5JFL+01', '103772',
  '6FPU7NE+01', 'B39N3ZG+01', 'ZVKHMNA-01', 'FR7JW9Y-01', 'A2V9Q4Q+01',
  'SMT2JMU+01', '9MBBP4D+01'
]

VerdeTransfer.run(old_lender, new_lender, loan_references)
