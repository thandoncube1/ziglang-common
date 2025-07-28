const std = @import("std");

const A = error{ ConnectionTimeoutError, DatabaseNotFound, OutOfMemory, InvalidToken };

const B = error{OutOfMemory};

fn cast(err: B) A {
    return err;
}

test "coerce error value" {
    const error_value = cast(B.OutOfMemory);
    try std.testing.expect(error_value == A.OutOfMemory);
}
