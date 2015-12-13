require 'openssl'

input = ARGF.read.strip
requirement = '0' * 6

n = 0
str = nil
md5 = nil

loop do
	str = input + n.to_s
	digest = OpenSSL::Digest::MD5.digest(str)
	md5 = digest.unpack("H*")[0]
	break if md5.start_with?(requirement)
	n += 1
end

puts "Found n: #{n} (#{str}) #{md5}" 
