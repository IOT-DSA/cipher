// Copyright (c) 2013-present, Iván Zaera Avellón - izaera@gmail.com

// This library is dually licensed under LGPL 3 and MPL 2.0. See file LICENSE for more information.

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of
// the MPL was not distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0/.

library cipher.random.auto_seed_block_ctr_random;

import "dart:typed_data";

import "package:bignum/bignum.dart";

import "package:dscipher/api.dart";
import "package:dscipher/random/block_ctr_random.dart";
import "package:dscipher/params/parameters_with_iv.dart";
import "package:dscipher/params/key_parameter.dart";

/**
 * An implementation of [SecureRandom] that uses a [BlockCipher] with CTR mode to generate random values and automatically
 * self reseeds itself after each request for data, in order to achieve forward security. See section 4.1 of the paper:
 * Practical Random Number Generation in Software (by John Viega).
 */
class AutoSeedBlockCtrRandom implements SecureRandom {

  BlockCtrRandom _delegate;

  var _inAutoReseed = false;
  var _autoReseedKeyLength;

  String get algorithmName => "${_delegate.cipher.algorithmName}/CTR/AUTO-SEED-PRNG";

  AutoSeedBlockCtrRandom(BlockCipher cipher) {
    _delegate = new BlockCtrRandom(cipher);
  }

  void seed(ParametersWithIV<KeyParameter> params) {
    _autoReseedKeyLength = params.parameters.key.length;
    _delegate.seed( params );
  }

  int nextUint8() => _autoReseedIfNeededAfter( () {
    return _delegate.nextUint8();
  });

  int nextUint16() => _autoReseedIfNeededAfter( () {
    return _delegate.nextUint16();
  });

  int nextUint32() => _autoReseedIfNeededAfter( () {
    return _delegate.nextUint32();
  });

  BigInteger nextBigInteger( int bitLength ) => _autoReseedIfNeededAfter( () {
    return _delegate.nextBigInteger(bitLength);
  });

  Uint8List nextBytes( int count ) => _autoReseedIfNeededAfter( () {
    return _delegate.nextBytes(count);
  });

  dynamic _autoReseedIfNeededAfter( dynamic closure ) {
    if( _inAutoReseed ) {
      return closure();
    } else {
      _inAutoReseed = true;
      var ret = closure();
      _doAutoReseed();
      _inAutoReseed = false;
      return ret;
    }
  }

  void _doAutoReseed() {
    var newKey = nextBytes(_autoReseedKeyLength);
    var newIV = nextBytes(_delegate.cipher.blockSize);
    var keyParam = new KeyParameter(newKey);
    var params = new ParametersWithIV(keyParam, newIV);
    _delegate.seed( params );
  }

}
