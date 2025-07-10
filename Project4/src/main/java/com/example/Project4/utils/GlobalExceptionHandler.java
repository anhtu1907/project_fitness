// package com.example.Project4.utils;

// import java.util.Map;

// import org.springframework.http.HttpStatus;
// import org.springframework.http.ResponseEntity;
// import org.springframework.web.bind.annotation.ControllerAdvice;
// import org.springframework.web.bind.annotation.ExceptionHandler;

// @ControllerAdvice
// public class GlobalExceptionHandler {
//      @ExceptionHandler(EmailNotFoundException.class)
//     public ResponseEntity<?> handleEmailNotFound(EmailNotFoundException ex) {
//         return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("message", ex.getMessage()));
//     }

//     @ExceptionHandler(IncorrectPasswordException.class)
//     public ResponseEntity<?> handleIncorrectPassword(IncorrectPasswordException ex) {
//         return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("message", ex.getMessage()));
//     }

//     @ExceptionHandler(AccountDisabledException.class)
//     public ResponseEntity<?> handleAccountDisabled(AccountDisabledException ex) {
//         return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("message", ex.getMessage()));
//     }

//     // Xử lý các lỗi khác (nếu muốn)
//     @ExceptionHandler(RuntimeException.class)
//     public ResponseEntity<?> handleOtherRuntime(RuntimeException ex) {
//         return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("message", ex.getMessage()));
//     }
// }
