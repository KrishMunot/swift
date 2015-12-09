// RUN: %target-swift-frontend -primary-file %s  -parse-as-library -emit-sil -O | FileCheck %s

private func recFunc(x: Int32) -> Int32 {
  if x > 0 {
    return recFunc(x - 1)
  }
  return 0
}

<<<<<<< HEAD
// Ensure that we do not inline self-recursive functions into other
// functions since doing so can result in large code growth if we run
// the inlining pass multiple times.

// CHECK-LABEL: sil hidden @_TF16inline_recursive6callitFT_Si
// CHECK: bb0:
// CHECK: [[FN:%.*]] = function_ref @_TF16inline_recursiveP33_38E63D320CFF538A1F98BBC31453B1EB7recFuncFSiSi
// CHECK: [[BUILTIN_INT:%.*]] = integer_literal $Builtin.Int64, 3
// CHECK: [[INT:%.*]] = struct $Int ([[BUILTIN_INT]] : $Builtin.Int64)
// CHECK: [[APPLY:%.*]] = apply [[FN]]([[INT]])
// CHECK: return [[APPLY]]
func callit() -> Int {
  return recFunc(3)
}
=======
//CHECK-LABEL: sil {{.*}}callit
// CHECK: bb0:
// CHECK-NEXT: integer_literal $Builtin.Int32, 0
// CHECK-NEXT: struct
// CHECK-NEXT: return

func callit() -> Int32 {
  return recFunc(3)
}

private func recFuncManyCalls(x: Int32) -> Int32 {
  if x > 4 {
    return recFuncManyCalls(x - 1)
    + recFuncManyCalls(x - 2)
    + recFuncManyCalls(x - 3)
    + recFuncManyCalls(x - 4)
    + recFuncManyCalls(x - 5)
  }
  return 0
}

// CHECK-LABEL: sil hidden {{.*}}callother
// CHECK: bb0:
// CHECK: [[FN:%.*]] = function_ref {{.*}}recFuncManyCalls
// CHECK: [[APPLY:%.*]] = apply [[FN]]
// CHECK-NOT: apply
// CHECK: return [[APPLY]]
func callother() -> Int32 {
  return recFuncManyCalls(10)
}
>>>>>>> refs/remotes/apple/master
