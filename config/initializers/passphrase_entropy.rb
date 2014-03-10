# PassphraseEntropy uses /usr/share/dict/words by default, this is not available
# on the demo environment

if Rails.env.demo?
  passphrase_entropy = PassphraseEntropy.new %w(apple banana cherry).join("/n")
  PassphraseEntropy.single = passphrase_entropy
end
