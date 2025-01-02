create table actions
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(255) not null,
    created_at timestamp    null,
    updated_at timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table brands
(
    id          bigint unsigned auto_increment
        primary key,
    name        varchar(255) not null,
    logo        varchar(255) null,
    description text         null,
    created_at  timestamp    null,
    updated_at  timestamp    null,
    constraint brands_name_unique
        unique (name)
)
    collate = utf8mb4_unicode_ci;

create table cache
(
    `key`      varchar(255) not null
        primary key,
    value      mediumtext   not null,
    expiration int          not null
)
    collate = utf8mb4_unicode_ci;

create table cache_locks
(
    `key`      varchar(255) not null
        primary key,
    owner      varchar(255) not null,
    expiration int          not null
)
    collate = utf8mb4_unicode_ci;

create table campaigns
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(255)                 not null,
    type       enum ('percentage', 'fixed') not null,
    value      decimal(10, 2)               not null,
    start_date datetime                     not null,
    end_date   datetime                     not null,
    is_active  tinyint(1) default 1         not null,
    image_url  varchar(255)                 null,
    created_at timestamp                    null,
    updated_at timestamp                    null
)
    collate = utf8mb4_unicode_ci;

create table categories
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(255)              not null,
    slug       varchar(255)              not null,
    image_url  varchar(255)              null,
    parent_id  bigint unsigned default 1 null,
    created_at timestamp                 null,
    updated_at timestamp                 null,
    constraint categories_slug_unique
        unique (slug),
    constraint categories_parent_id_foreign
        foreign key (parent_id) references categories (id)
            on delete set null
)
    collate = utf8mb4_unicode_ci;

create table colors
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(255)               not null,
    hex_code   varchar(255)               null,
    chance     decimal(5, 2) default 1.00 not null,
    created_at timestamp                  null,
    updated_at timestamp                  null
)
    collate = utf8mb4_unicode_ci;

create table coupons
(
    id          bigint unsigned auto_increment
        primary key,
    code        varchar(255)                 not null,
    type        enum ('percentage', 'fixed') not null,
    value       decimal(10, 2)               not null,
    start_date  datetime                     not null,
    end_date    datetime                     not null,
    usage_limit int                          null,
    used_count  int        default 0         not null,
    is_active   tinyint(1) default 1         not null,
    created_at  timestamp                    null,
    updated_at  timestamp                    null,
    constraint coupons_code_unique
        unique (code)
)
    collate = utf8mb4_unicode_ci;

create table failed_jobs
(
    id         bigint unsigned auto_increment
        primary key,
    uuid       varchar(255)                          not null,
    connection text                                  not null,
    queue      text                                  not null,
    payload    longtext                              not null,
    exception  longtext                              not null,
    failed_at  timestamp default current_timestamp() not null,
    constraint failed_jobs_uuid_unique
        unique (uuid)
)
    collate = utf8mb4_unicode_ci;

create table job_batches
(
    id             varchar(255) not null
        primary key,
    name           varchar(255) not null,
    total_jobs     int          not null,
    pending_jobs   int          not null,
    failed_jobs    int          not null,
    failed_job_ids longtext     not null,
    options        mediumtext   null,
    cancelled_at   int          null,
    created_at     int          not null,
    finished_at    int          null
)
    collate = utf8mb4_unicode_ci;

create table jobs
(
    id           bigint unsigned auto_increment
        primary key,
    queue        varchar(255)     not null,
    payload      longtext         not null,
    attempts     tinyint unsigned not null,
    reserved_at  int unsigned     null,
    available_at int unsigned     not null,
    created_at   int unsigned     not null
)
    collate = utf8mb4_unicode_ci;

create index jobs_queue_index
    on jobs (queue);

create table materials
(
    id          bigint unsigned auto_increment
        primary key,
    name        varchar(255)               not null,
    description text                       null,
    chance      decimal(5, 2) default 1.00 not null,
    created_at  timestamp                  null,
    updated_at  timestamp                  null
)
    collate = utf8mb4_unicode_ci;

create table migrations
(
    id        int unsigned auto_increment
        primary key,
    migration varchar(255) not null,
    batch     int          not null
)
    collate = utf8mb4_unicode_ci;

create table notifications
(
    id         bigint unsigned auto_increment
        primary key,
    `from`     varchar(255) not null,
    title      varchar(255) not null,
    message    text         not null,
    created_at timestamp    null,
    updated_at timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table password_reset_tokens
(
    email      varchar(255) not null
        primary key,
    token      varchar(255) not null,
    created_at timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table payment_methods
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(255)         not null,
    is_active  tinyint(1) default 1 not null,
    created_at timestamp            null,
    updated_at timestamp            null
)
    collate = utf8mb4_unicode_ci;

create table products
(
    id          bigint unsigned auto_increment
        primary key,
    name        varchar(255)         not null,
    description text                 not null,
    image_url   varchar(255)         null,
    price       decimal(10, 2)       not null,
    brand_id    bigint unsigned      not null,
    is_active   tinyint(1) default 1 not null,
    best_seller tinyint(1) default 0 not null,
    created_at  timestamp            null,
    updated_at  timestamp            null,
    constraint products_brand_id_foreign
        foreign key (brand_id) references brands (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table campaign_product
(
    id          bigint unsigned auto_increment
        primary key,
    campaign_id bigint unsigned not null,
    product_id  bigint unsigned not null,
    created_at  timestamp       null,
    updated_at  timestamp       null,
    constraint campaign_product_campaign_id_foreign
        foreign key (campaign_id) references campaigns (id)
            on delete cascade,
    constraint campaign_product_product_id_foreign
        foreign key (product_id) references products (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table category_product
(
    id          bigint unsigned auto_increment
        primary key,
    category_id bigint unsigned not null,
    product_id  bigint unsigned not null,
    constraint category_product_category_id_foreign
        foreign key (category_id) references categories (id)
            on delete cascade,
    constraint category_product_product_id_foreign
        foreign key (product_id) references products (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table roles
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(255) not null,
    created_at timestamp    null,
    updated_at timestamp    null,
    constraint roles_name_unique
        unique (name)
)
    collate = utf8mb4_unicode_ci;

create table action_role
(
    id        bigint unsigned auto_increment
        primary key,
    role_id   bigint unsigned not null,
    action_id bigint unsigned not null,
    constraint action_role_action_id_foreign
        foreign key (action_id) references actions (id)
            on delete cascade,
    constraint action_role_role_id_foreign
        foreign key (role_id) references roles (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table sessions
(
    id            varchar(255)    not null
        primary key,
    user_id       bigint unsigned null,
    ip_address    varchar(45)     null,
    user_agent    text            null,
    payload       longtext        not null,
    last_activity int             not null
)
    collate = utf8mb4_unicode_ci;

create index sessions_last_activity_index
    on sessions (last_activity);

create index sessions_user_id_index
    on sessions (user_id);

create table sizes
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(255)               not null,
    code       varchar(255)               null,
    chance     decimal(5, 2) default 1.00 not null,
    category   varchar(255)               not null,
    created_at timestamp                  null,
    updated_at timestamp                  null
)
    collate = utf8mb4_unicode_ci;

create table product_variants
(
    id          bigint unsigned auto_increment
        primary key,
    product_id  bigint unsigned not null,
    sku         varchar(255)    not null,
    name        varchar(255)    not null,
    price       decimal(10, 2)  not null,
    color_id    bigint unsigned null,
    size_id     bigint unsigned null,
    material_id bigint unsigned null,
    created_at  timestamp       null,
    updated_at  timestamp       null,
    constraint product_variants_sku_unique
        unique (sku),
    constraint product_variants_color_id_foreign
        foreign key (color_id) references colors (id)
            on delete set null,
    constraint product_variants_material_id_foreign
        foreign key (material_id) references materials (id)
            on delete set null,
    constraint product_variants_product_id_foreign
        foreign key (product_id) references products (id)
            on delete cascade,
    constraint product_variants_size_id_foreign
        foreign key (size_id) references sizes (id)
            on delete set null
)
    collate = utf8mb4_unicode_ci;

create table stocks
(
    id         bigint unsigned auto_increment
        primary key,
    sku        varchar(255) not null,
    quantity   int          not null,
    created_at timestamp    null,
    updated_at timestamp    null,
    constraint stocks_sku_foreign
        foreign key (sku) references product_variants (sku)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table suppliers
(
    id             bigint unsigned auto_increment
        primary key,
    name           varchar(255) not null,
    contact_person varchar(255) not null,
    email          varchar(255) not null,
    phone          varchar(255) not null,
    address        text         not null,
    created_at     timestamp    null,
    updated_at     timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table supplied_product_variants
(
    id                 bigint unsigned auto_increment
        primary key,
    product_variant_id bigint unsigned not null,
    supplier_id        bigint unsigned not null,
    cost               decimal(10, 2)  not null,
    quantity           int             not null,
    created_at         timestamp       null,
    updated_at         timestamp       null,
    constraint supplied_product_variants_product_variant_id_foreign
        foreign key (product_variant_id) references product_variants (id)
            on delete cascade,
    constraint supplied_product_variants_supplier_id_foreign
        foreign key (supplier_id) references suppliers (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table users
(
    id                bigint unsigned auto_increment
        primary key,
    name              varchar(255) not null,
    email             varchar(255) not null,
    tel_no            varchar(255) null,
    email_verified_at timestamp    null,
    password          varchar(255) not null,
    remember_token    varchar(100) null,
    created_at        timestamp    null,
    updated_at        timestamp    null,
    constraint users_email_unique
        unique (email),
    constraint users_tel_no_unique
        unique (tel_no)
)
    collate = utf8mb4_unicode_ci;

create table action_logs
(
    id         bigint unsigned auto_increment
        primary key,
    user_id    bigint unsigned                not null,
    action     varchar(255)                   not null,
    target     varchar(255)                   not null,
    status     varchar(255) default 'success' not null,
    ip_address varchar(45)                    null,
    details    text                           null,
    created_at timestamp                      null,
    updated_at timestamp                      null,
    constraint action_logs_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table addresses
(
    id           bigint unsigned auto_increment
        primary key,
    user_id      bigint unsigned not null,
    country      varchar(255)    not null,
    city         varchar(255)    not null,
    neighborhood varchar(255)    not null,
    building_no  varchar(255)    not null,
    apartment_no varchar(255)    null,
    created_at   timestamp       null,
    updated_at   timestamp       null,
    constraint addresses_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table blogs
(
    id         bigint unsigned auto_increment
        primary key,
    title      varchar(255)                                            not null,
    content    text                                                    not null,
    user_id    bigint unsigned                                         not null,
    image_url  varchar(255)                                            null,
    status     enum ('draft', 'published', 'archived') default 'draft' not null,
    created_at timestamp                                               null,
    updated_at timestamp                                               null,
    constraint blogs_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table coupon_user
(
    id         bigint unsigned auto_increment
        primary key,
    coupon_id  bigint unsigned not null,
    user_id    bigint unsigned not null,
    used_count int default 0   not null,
    created_at timestamp       null,
    updated_at timestamp       null,
    constraint coupon_user_coupon_id_foreign
        foreign key (coupon_id) references coupons (id)
            on delete cascade,
    constraint coupon_user_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table login_logs
(
    id         bigint unsigned auto_increment
        primary key,
    user_id    bigint unsigned                      not null,
    event      enum ('login', 'logout', 'register') not null,
    status     varchar(255) default 'success'       not null,
    ip_address varchar(45)                          null,
    created_at timestamp                            null,
    updated_at timestamp                            null,
    constraint login_logs_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table notification_user
(
    id              bigint unsigned auto_increment
        primary key,
    notification_id bigint unsigned      not null,
    user_id         bigint unsigned      not null,
    is_read         tinyint(1) default 0 not null,
    created_at      timestamp            null,
    updated_at      timestamp            null,
    constraint notification_user_notification_id_foreign
        foreign key (notification_id) references notifications (id)
            on delete cascade,
    constraint notification_user_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table orders
(
    id                bigint unsigned auto_increment
        primary key,
    user_id           bigint unsigned                                          not null,
    payment_method_id bigint unsigned                                          not null,
    address_id        bigint unsigned                                          not null,
    used_coupon       text                                                     null,
    order_number      varchar(255)                                             not null,
    total_amount      decimal(10, 2)                                           not null,
    payment_id        varchar(255)                                             null,
    payment_status    varchar(255) default 'pending'                           not null,
    status            enum ('pending', 'processing', 'completed', 'cancelled') not null,
    notes             text                                                     null,
    created_at        timestamp                                                null,
    updated_at        timestamp                                                null,
    constraint orders_order_number_unique
        unique (order_number),
    constraint orders_address_id_foreign
        foreign key (address_id) references addresses (id)
            on delete cascade,
    constraint orders_payment_method_id_foreign
        foreign key (payment_method_id) references payment_methods (id),
    constraint orders_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table invoices
(
    id              bigint unsigned auto_increment
        primary key,
    order_id        bigint unsigned not null,
    invoice_number  varchar(255)    not null,
    total_amount    decimal(10, 2)  not null,
    status          varchar(255)    not null,
    payment_details text            null,
    created_at      timestamp       null,
    updated_at      timestamp       null,
    constraint invoices_invoice_number_unique
        unique (invoice_number),
    constraint invoices_order_id_foreign
        foreign key (order_id) references orders (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table order_details
(
    id                 bigint unsigned auto_increment
        primary key,
    order_id           bigint unsigned not null,
    product_variant_id bigint unsigned not null,
    quantity           int             not null,
    price              decimal(10, 2)  not null,
    created_at         timestamp       null,
    updated_at         timestamp       null,
    constraint order_details_order_id_foreign
        foreign key (order_id) references orders (id)
            on delete cascade,
    constraint order_details_product_variant_id_foreign
        foreign key (product_variant_id) references product_variants (id)
)
    collate = utf8mb4_unicode_ci;

create table product_reviews
(
    id          bigint unsigned auto_increment
        primary key,
    product_id  bigint unsigned      not null,
    user_id     bigint unsigned      not null,
    rating      int                  not null,
    comment     text                 null,
    is_approved tinyint(1) default 0 not null,
    created_at  timestamp            null,
    updated_at  timestamp            null,
    constraint product_reviews_product_id_user_id_unique
        unique (product_id, user_id),
    constraint product_reviews_product_id_foreign
        foreign key (product_id) references products (id)
            on delete cascade,
    constraint product_reviews_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table request_complaints
(
    id         bigint unsigned auto_increment
        primary key,
    user_id    bigint unsigned                                                                       not null,
    RorC       enum ('Request', 'Complaint')                                                         not null,
    subject    varchar(255)                                                                          not null,
    category   enum ('Category', 'Brand', 'Product', 'User', 'Review', 'Order', 'Campaign', 'Other') not null,
    message    text                                                                                  not null,
    status     enum ('Pending', 'Reviewed', 'Resolved') default 'Pending'                            not null,
    created_at timestamp                                                                             null,
    updated_at timestamp                                                                             null,
    constraint request_complaints_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table returns_exchanges
(
    id                 bigint unsigned auto_increment
        primary key,
    order_id           bigint unsigned                                       not null,
    product_variant_id bigint unsigned                                       not null,
    type               enum ('return', 'exchange')                           not null,
    reason             text                                                  not null,
    status             enum ('pending', 'approved', 'rejected', 'completed') not null,
    created_at         timestamp                                             null,
    updated_at         timestamp                                             null,
    constraint returns_exchanges_order_id_foreign
        foreign key (order_id) references orders (id)
            on delete cascade,
    constraint returns_exchanges_product_variant_id_foreign
        foreign key (product_variant_id) references product_variants (id)
)
    collate = utf8mb4_unicode_ci;

create table role_user
(
    id      bigint unsigned auto_increment
        primary key,
    user_id bigint unsigned not null,
    role_id bigint unsigned not null,
    constraint role_user_role_id_foreign
        foreign key (role_id) references roles (id)
            on delete cascade,
    constraint role_user_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table shopping_carts
(
    id         bigint unsigned auto_increment
        primary key,
    user_id    bigint unsigned null,
    coupon_id  bigint unsigned null,
    created_at timestamp       null,
    updated_at timestamp       null,
    constraint shopping_carts_coupon_id_foreign
        foreign key (coupon_id) references coupons (id)
            on delete cascade,
    constraint shopping_carts_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table shopping_cart_items
(
    id                 bigint unsigned auto_increment
        primary key,
    shopping_cart_id   bigint unsigned not null,
    product_variant_id bigint unsigned not null,
    quantity           int             not null,
    created_at         timestamp       null,
    updated_at         timestamp       null,
    constraint shopping_cart_items_product_variant_id_foreign
        foreign key (product_variant_id) references product_variants (id)
            on delete cascade,
    constraint shopping_cart_items_shopping_cart_id_foreign
        foreign key (shopping_cart_id) references shopping_carts (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;

create table wishlists
(
    id         bigint unsigned auto_increment
        primary key,
    user_id    bigint unsigned not null,
    product_id bigint unsigned not null,
    created_at timestamp       null,
    updated_at timestamp       null,
    constraint wishlists_product_id_foreign
        foreign key (product_id) references products (id)
            on delete cascade,
    constraint wishlists_user_id_foreign
        foreign key (user_id) references users (id)
            on delete cascade
)
    collate = utf8mb4_unicode_ci;