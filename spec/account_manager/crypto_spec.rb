require 'spec_helper'

module AccountManager
  describe Crypto do
    describe '.new_salt' do
      it 'returns a 20 character hex string' do
        Crypto.new_salt.should match /[a-f0-9]{20}/
      end
    end

    describe '.hash_password' do
      it 'creates a SSHA password hash' do
        Crypto.hash_password('doodle', type: :ssha).should match /^{SSHA}/
      end

      it 'creates a SHA password hash' do
        Crypto.hash_password('doodle', type: :sha).should match /^{SHA}/
      end

      it 'should complain if you pass it an unsupported hash type' do
        expect {
          Crypto.hash_password('doodle', type: :md5)
        }.should raise_error "Unsupported password hash type md5"
      end
    end

    describe '.check_ssha_password' do

      before :all do
        @hash = Crypto.hash_password 'doodle', type: :ssha
      end

      it 'validates a correct password against an SSHA hash' do
        Crypto.check_ssha_password('doodle', @hash).should be true
      end

      it 'does not validate an incorrect password against an SSHA hash' do
        Crypto.check_ssha_password('Doodle', @hash).should be false
      end
    end

    describe '.check_sha_password' do


      before :all do
        @hash = Crypto.hash_password 'doodle', type: :sha
      end

      it 'validates a correct password against an SHA hash' do
        Crypto.check_sha_password('doodle', @hash).should be true
      end

      it 'does not validate an incorrect password against an SHA hash' do
        Crypto.check_sha_password('Doodle', @hash).should be false
      end
    end

    describe '.check_password' do
      it 'identifies and validates SSHA passwords' do
        hash = Crypto.hash_password 'doodle', type: :ssha
        Crypto.check_password 'doodle', hash
      end

      it 'identifies and validates SHA passwords' do
        hash = Crypto.hash_password 'doodle', type: :sha
        Crypto.check_password 'doodle', hash
      end

      it 'complains if you try to use an unsupported password hash type' do
        expect {
          Crypto.check_password 'doodle', '{MD5}somehash'
        }.should raise_error 'Unsupported password hash type md5'
      end

      it "complains if you don't have a hash prefix string such as {SHA} in your hash" do
        expect {
          Crypto.check_password 'doodle', 'badhash'
        }.should raise_error 'No hash prefix. Expected something like {SHA} at the beginning of the hash.'
      end
    end

  end
end
