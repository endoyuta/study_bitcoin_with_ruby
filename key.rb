#!/usr/bin/env ruby

require 'openssl'
# require 'socket'

def hash256(txt)
	OpenSSL::Digest::SHA256.digest(txt)
end

def hash160(txt)
	OpenSSL::Digest::RIPEMD160.digest(txt)
end

BASE58 = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
def encode_base58(plain)
	num = plain.unpack("H*").first.hex
	res = ''
	while num > 0
		res += BASE58[num % 58]
		num /= 58
	end
	plain.each_byte do |c|
		break if c != 0
		res += BASE58[0]
	end
	return res.reverse
end

def decode_base58(encoded)
	num = 0
	encoded.each_char do |c|
		num *= 58
		num += BASE58.index(c)
	end
	res = num.to_s(16)
	if res % 2 == 1 then
		res = '0' + res
	end
	encoded.each_char do |c|
		break if c != BASE58[0]
		res += '00'
	end
	return [res].pack('H*')
end

plain = 'hoge'
hoge = hash256(hash256(plain))
puts hoge
page = hash160(hash160(plain))
puts page