package aptech.finalproject.emums;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public enum PredefinedPermission {

    // User Management
    MANAGE_USERS("MANAGE_USERS", "Create, update, delete users"),
    VIEW_USERS("VIEW_USERS", "View user profiles"),
    RESET_PASSWORD("RESET_PASSWORD", "Reset user passwords"),
    ASSIGN_ROLES("ASSIGN_ROLES", "Assign roles to users"),

    // Role & Permission
    MANAGE_ROLES("MANAGE_ROLES", "Create or modify roles"),
    VIEW_ROLES("VIEW_ROLES", "View role list"),
    MANAGE_PERMISSIONS("MANAGE_PERMISSIONS", "Assign permissions to roles"),

    // Product Management (e-commerce)
    MANAGE_PRODUCTS("MANAGE_PRODUCTS", "Manage products"),
    CREATE_PRODUCT("CREATE_PRODUCT", "Create new product"),
    UPDATE_PRODUCT("UPDATE_PRODUCT", "Edit existing product"),
    DELETE_PRODUCT("DELETE_PRODUCT", "Delete product"),
    VIEW_PRODUCTS("VIEW_PRODUCTS", "View product catalog"),

    // Order & Transaction
    MANAGE_ORDERS("MANAGE_ORDERS", "Manage orders"),
    PROCESS_REFUNDS("PROCESS_REFUNDS", "Process customer refunds"),
    VIEW_INVOICES("VIEW_INVOICES", "View generated invoices"),

    // Content Management (CMS / LMS)
    MANGE_POST("MANGE_POST", "Create, update, delete posts"),
    CREATE_POST("CREATE_POST", "Create a new post or article"),
    EDIT_POST("EDIT_POST", "Edit existing content"),
    DELETE_POST("DELETE_POST", "Remove content"),
    PUBLISH_CONTENT("PUBLISH_CONTENT", "Publish content to public"),

    // Report & Analytics
    VIEW_REPORTS("VIEW_REPORTS", "View analytic reports"),
    EXPORT_DATA("EXPORT_DATA", "Export data to CSV or Excel"),

    // Settings & Configuration
    MANAGE_SETTINGS("MANAGE_SETTINGS", "Change system configuration"),
    ACCESS_ADMIN_PANEL("ACCESS_ADMIN_PANEL", "Access admin dashboard"),

    // Notification & Messaging
    SEND_NOTIFICATIONS("SEND_NOTIFICATIONS", "Send user notifications"),
    VIEW_MESSAGES("VIEW_MESSAGES", "View user messages"),

    // Audit
    VIEW_AUDIT_LOGS("VIEW_AUDIT_LOGS", "View system activity logs");


    private String permission;
    private String description;
}
