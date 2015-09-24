<?php

class Localization
{
    const LANG_EN= 'en';
    const LANG_BG= 'bg';
    const LAND_DEFAULT = self::LANG_EN;

    public static $string = [
        "greeting_header_hello" => [
            self::LANG_EN => "Hello",
            self::LANG_BG => "�������"
        ],
        "informal_hello" => [
            self::LANG_EN => "Hello",
            self::LANG_BG => "�������"
        ],
        "welcome_message" => [
            self::LANG_EN => "Welcome to out site",
            self::LANG_BG => "����� ����� � ����� ����"
        ]
    ];
}