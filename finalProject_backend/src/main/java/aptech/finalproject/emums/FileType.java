package aptech.finalproject.emums;

import lombok.*;

import java.util.List;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public enum FileType {
    IMAGE("image",
            List.of(
                    "image/jpeg", "image/png", "image/gif", "image/bmp",
                    "image/webp", "image/svg+xml", "image/heic", "image/heif", "image/tiff"
            ),
            List.of(
                    "jpg", "jpeg", "png", "gif", "bmp", "webp", "svg", "heic", "heif", "tiff", "tif"
            )
    ),


    VIDEO("video",
            List.of(
                    "video/mp4", "video/mpeg", "video/webm", "video/x-msvideo",
                    "video/quicktime", "video/x-ms-wmv", "video/3gpp", "video/x-flv"
            ),
            List.of(
                    "mp4", "mpeg", "webm", "avi", "mov", "wmv", "3gp", "flv"
            )
    ),

    AUDIO("audio",
            List.of(
                    "audio/mpeg", "audio/ogg", "audio/wav", "audio/x-wav",
                    "audio/webm", "audio/mp4", "audio/x-aac", "audio/flac"
            ),
            List.of(
                    "mp3", "ogg", "wav", "aac", "webm", "flac", "m4a"
            )
    ),

    DOCUMENT("document",
            List.of(
                    "application/pdf",
                    "application/msword",
                    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                    "application/vnd.ms-excel",
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    "application/vnd.ms-powerpoint",
                    "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                    "text/plain",
                    "text/csv",
                    "application/rtf",
                    "application/vnd.oasis.opendocument.text",
                    "application/vnd.oasis.opendocument.spreadsheet"
            ),
            List.of(
                    "pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx",
                    "txt", "csv", "rtf", "odt", "ods"
            )),

    ARCHIVE("archive",
            List.of(
                    "application/zip",
                    "application/x-tar",
                    "application/x-7z-compressed",
                    "application/x-rar-compressed",
                    "application/gzip"
            ),
            List.of(
                    "zip", "tar", "7z", "rar", "gz"
            )),


//    CODE("code",
//            List.of(
//                    "text/x-java-source", "text/javascript", "application/javascript",
//                    "text/html", "text/css", "application/json", "application/xml"
//            ),
//            List.of(
//                    "java", "js", "ts", "html", "css", "json", "xml"
//            )),
//
//    FONT("font",
//            List.of(
//                    "font/otf", "font/ttf", "application/font-woff", "application/font-woff2"
//            ),
//            List.of(
//                    "otf", "ttf", "woff", "woff2"
//            ))
    ;


    private String typeName;
    private List<String> mineType;
    private List<String> extension;

}
