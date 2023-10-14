class User < ApplicationRecord
    validates :name, :phone, :email, :cpf, presence: true
    validates :email, format: { with: /\A(.+)@(.+)\z/ }, uniqueness: { case_sensitive: false }, length: { minimum: 4, maximum: 254 }
    validate :validacao_cpf

    private
    BAN_LIST = %w[
    00000000000
    11111111111
    22222222222
    33333333333
    44444444444
    55555555555
    66666666666
    77777777777
    88888888888
    99999999999
    12345678909
    01234567890
  ].freeze

    def validacao_cpf
        return if cpf.blank?
        return if BAN_LIST.include?(cpf)
        unless cpf_valido?(cpf)
            errors.add(:cpf, "Inválido")
        end
    end
    

    def cpf_valido?(cpf)
        cpf_num = cpf.scan(/\d/).map(&:to_i)
      
        return false unless cpf_valido_tam?(cpf_num)
        return false if cpf_repeat?(cpf_num)
      
        digito_1 = proc_dig(cpf_num, 10)
        digito_2 = proc_dig(cpf_num, 11)
      
        digito_1 == cpf_num[9] && digito_2 == cpf_num[10]
      end
      
      def cpf_valido_tam?(cpf_num)
        cpf_num.length == 11
      end
      
      def cpf_repeat?(cpf_num)
        cpf_num.uniq.length == 1
      end
      
      def proc_dig(cpf_num, pos)
        soma = cpf_num[0..(pos - 2)].each_with_index.sum { |digito, index| digito * (pos - index) }
        result = soma % 11
        result < 2 ? 0 : 11 - result
      end
      

end
