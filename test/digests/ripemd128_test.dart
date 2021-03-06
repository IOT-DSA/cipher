// Copyright (c) 2013-present, Iván Zaera Avellón - izaera@gmail.com

// This library is dually licensed under LGPL 3 and MPL 2.0. See file LICENSE for more information.

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of
// the MPL was not distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0/.

library cipher.test.digests.ripemd128_test;

import "package:dscipher/cipher.dart";
import "package:dscipher/impl/base.dart";

import "../test/digest_tests.dart";

/// NOTE: the expected results for these tests are computed using the Java version of Bouncy Castle.
void main() {

  initCipher();

  runDigestTests( new Digest("RIPEMD-128"), [

    "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
    "3e67e64143573d714263ed98b8d85c1d",

    "En un lugar de La Mancha, de cuyo nombre no quiero acordarme...",
    "6a022533ba64455b63cdadbdc57dcc3d",

  ]);

}

