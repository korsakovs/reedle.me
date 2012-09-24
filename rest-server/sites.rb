# encoding: utf-8

$SITES = [

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Lenta.Ru",
        :id         => "lenta-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?:\/\/(www\\.)?lenta\\.ru/news/\\d+/\\d+/\\d+/\\w+"
            },
            {
                :categories => ["Articles"],
                :regexp     => "https?:\/\/(www\\.)?lenta\\.ru/articles/\\d+/\\d+/\\d+/\\w+"
            },
            {
                :categories => ["Videos"],
                :regexp     => "https?:\/\/(www\\.)?lenta\\.ru/video/\\w+/\\w+"
            },
            {
                :categories => ["Photos"],
                :regexp     => "https?:\/\/(www\\.)?lenta\\.ru/photo/\\d+/\\d+/\\d+/\\w+"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Gazeta.Ru",
        :id         => "gazeta-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?:\/\/(www\\.)?gazeta\\.ru/\\w+/\\d+/\\d+/\\d+/\\d+\\.shtml"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "IT" ],
        :title      => "Habrahabr",
        :id         => "habrahabr-ru",
        :urls       => [
            {
                :categories => ["IT"],
                :regexp     => "https?:\/\/(www\\.)?habrahabr\\.ru/post/\\d+"
            },
            {
                :categories => ["IT"],
                :regexp     => "https?:\/\/(www\\.)?habrahabr\\.ru/company/\\w+/blog/\\d+"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "Blogs" ],
        :title      => "Livejournal.Ru",
        :id         => "livejournal-ru",
        :urls       => [
            {
                :categories => ["Blogs"],
                :regexp     => "https?:\/\/(www\\.)?\\w+\\.livejournal\\.ru/\\d+\\.html"
            }
        ]
    },

    {
        :countries  => [ "WWW" ],
        :categories => [ "Blogs" ],
        :title      => "Livejournal.Com",
        :id         => "livejournal-com",
        :urls       => [
            {
                :categories => ["Blogs"],
                :regexp     => "https?:\/\/(www\\.)?\\w+\\.livejournal\\.com/\\d+\\.html"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Omskpress",
        :id         => "omskpress-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?:\/\/(www\\.)?omskpress\\.ru/news/\\w+"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Город 55",
        :id         => "gorod55-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?:\/\/(www\\.)?gorod55\\.ru/news/article/show/\\?rubric=(\\d+)&id=(\\d+)"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "ОмскИнформ",
        :id         => "omskinform-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?:\/\/(www\\.)?omskinform\\.ru/main\\.php\\?id=1&nid=(\\d+)"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "НГС55",
        :id         => "ngs55-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?:\/\/(www\\.)?ngs55\\.ru/news/\\d+/view"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Инфомск",
        :id         => "infomsk-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?:\/\/(www\\.)?infomsk\\.ru/\\w+/news/\\w+"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "LifeNews",
        :id         => "lifenews-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?:\/\/(www\\.)?lifenews\\.ru/news/\\d+"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "РиаНовости",
        :id         => "ria-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?:\/\/(www\\.)?ria\\.ru/\\w+/\\d+/\\d+.html"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Newsru.com",
        :id         => "newsru-com",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?:\/\/(www\\.)?newsru\\.com/\\w+/\\w+/\\w+.html"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Новости@Mail.Ru",
        :id         => "news-mail-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?:\/\/(www\\.)?news\\.mail\\.ru/\\w+/\\d+",
            }
        ]
    },

    {
        # TODO: Echo have blogs
        :countries  => [ "RU" ],
        :categories => [ "News", "Politics" ],
        :title      => "Эхо Москвы",
        :id         => "echo.msk.ru",
        :urls       => [
            {
                :categories => ["News", "Politics"],
                :regexp     => "https?:\/\/(www\\.)?echo\\.msk\\.ru/news/\\d+-echo\\.html"
            },
            {
                :categories => ["Politics", "Blogs"],
                :regexp     => "https?:\/\/(www\\.)?echo\\.msk\\.ru/blog/\\w+/\\d+-echo"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "РБК",
        :id         => "rbc-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?:\/\/(www\\.)?top\\.rbc\\.ru/\\w+/\\d+/\\d+/\\d+/\\d+\\.shtml"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News", "Business" ],
        :title      => "РБК daily",
        :id         => "rbc-dayly-ru",
        :urls       => [
            {
                :categories => ["News", "Business"],
                :regexp     => "https?:\/\/(www\\.)?rbcdaily\\.ru/\\d+/\\d+/\\d+/\\w+/\\d+"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News", "IT"],
        :title      => "Руформатор",
        :id         => "ruformator-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?:\/\/(www\\.)?ruformator\\.ru/\\w+/\\d+/[A-Za-z0-9_-]+"
            }
        ]
    },

    {
        # TODO: Investigate: Warning: Could not update information. Error: 404 => Net::HTTPNotFound for http://mnenia.ru/rubric/finance/centralnyy-bank-reshil-borotsya-s-inflyaciey -- unhandled response
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Мнения.ру",
        :id         => "mnenia-ru",
        :urls => [
            {
                :categories => ["Politics"],
                :regexp     => "https?:\/\/(www\\.)?mnenia\\.ru/rubric/politics/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Finance"],
                :regexp     => "https?:\/\/(www\\.)?mnenia\\.ru/rubric/finance/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Culture"],
                :regexp     => "https?:\/\/(www\\.)?mnenia\\.ru/rubric/culture/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["IT"],
                :regexp     => "https?:\/\/(www\\.)?mnenia\\.ru/rubric/tech/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?:\/\/(www\\.)?mnenia\\.ru/rubric/society/[A-Za-z0-9_-]+"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Новая Газета",
        :id         => "novayagazeta-ru",
        :urls       => [
            {
                :categories => ["Blogs"],
                :regexp     => "https?:\/\/(www\\.)?novayagazeta\\.ru/columns/\\d+\\.html"
            },
            {
                :categories => ["Politics"],
                :regexp     => "https?:\/\/(www\\.)?novayagazeta\\.ru/politics/\\d+\\.html"
            },
            {
                :categories => ["Inquests"],
                :regexp     => "https?:\/\/(www\\.)?novayagazeta\\.ru/inquests/\\d+\\.html"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?:\/\/(www\\.)?novayagazeta\\.ru/society/\\d+\\.html"
            },
            {
                :categories => ["Culture"],
                :regexp     => "https?:\/\/(www\\.)?novayagazeta\\.ru/arts/\\d+\\.html"
            },
            {
                :categories => ["Sports"],
                :regexp     => "https?:\/\/(www\\.)?novayagazeta\\.ru/sports/\\d+\\.html"
            },
            {
                :categories => [],
                :regexp     => "https?:\/\/(www\\.)?novayagazeta\\.ru/comments/\\d+\\.html"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Радио Свобода",
        :id         => "svobodanews-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?:\/\/(www\\.)?svobodanews\\.ru/content/article/\\d+\\.html"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Ридус",
        :id         => "ridus-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?ridus\\.ru/news/\\d+"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["Sports"],
        :title      => "Sports.Ru",
        :id         => "sports-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?sports\\.ru/tribuna/blogs/\\w+/\\d+\\.html"
            },
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?sports\\.ru/(football|hockey|basketball|automoto|tennis|boxing|biathlon|others)/\\d+\\.html"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["Sports"],
        :title      => "Чемпионат.com",
        :id         => "championat-com",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?championat\\.com/(auto|football|hockey|tennis|basketball|boxing|voleyball|poker|other|business)/(news|article)-\\d+-[A-Za-z0-9_-]+\\.html"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["Sports"],
        :title      => "Sportbox.ru",
        :id         => "sportbox-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?:\/\/(www\\.)?news\\.sportbox\\.ru/Vidy_sporta/(Futbol|Hokkej|Basketbol|Avtosport|Biatlon|Volejbol|Tennis|Formula_1|Boks|plavanie)/[A-Za-z0-9_-]+(/[A-Za-z0-9_-]+)?/spbnews_[A-Za-z0-9_-]+"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "KP.RU",
        :id         => "kp-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?:\/\/(www\\.)?kp\\.ru/online/news/\\d+"
            },
            {
                :categories => [],
                :regexp     => "https?:\/\/(www\\.)?kp\\.ru/daily/\\d+/\\d+"
            },
            {
                :categories => ["Photos"],
                :regexp     => "https?:\/\/(www\\.)?kp\\.ru/photo/(gallery|\\d+)/\\d+"
            },
            {
                :categories => ["Videos"],
                :regexp     => "https?:\/\/(www\\.)?kp\\.ru/video/\\d+"
            }
        ]
    },

    {
        :countries  => ["US"],
        :categories => ["Blogs"],
        :title      => "Сноб",
        :id         => "snob-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?snob\\.ru/selected/entry/\\d+"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["Auto"],
        :title      => "Motor",
        :id         => "motor-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?://(www\\.)?motor\\.ru/(news|articles)/\\d+/\\d+/\\d+/\\w+"
            },
            {
                :categories => ["Photos"],
                :regexp     => "https?://(www\\.)?motor\\.ru/photo/\\d+/\\d+/\\d+/\\w+"
            },
            {
                :categories => ["Videos"],
                :regexp     => "https?://(www\\.)?motor\\.ru/video/\\d+/\\d+/\\d+/\\w+"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Интерфакс",
        :id         => "intefrax-ru",
        :urls       => [
            {
                :categories => ["Politics"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/politics/txt.asp?id=\\d+"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/society/txt.asp?id=\\d+"
            },
            {
                :categories => ["Business"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/business/txt.asp?id=\\d+"
            },
            {
                :categories => ["Sport"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/sport/txt.asp?id=\\d+"
            },
            {
                :categories => ["Culture"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/culture/txt.asp?id=\\d+"
            },
            {
                :categories => ["Photos"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/photo.asp?id=\\d+"
            },
            {
                :categories => ["Videos"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/video.asp?id=\\d+"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Дни.Ру",
        :id         => "dni-ru",
        :urls       => [
            {
                :categories => ["Politics"],
                :regexp     => "https?://(www\\.)?dni\\.ru/polit/\\d+/\\d+/\\d+/\\d+\\.html"
            },
            {
                :categories => ["Economics"],
                :regexp     => "https?://(www\\.)?dni\\.ru/economy/\\d+/\\d+/\\d+/\\d+\\.html"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?://(www\\.)?dni\\.ru/society/\\d+/\\d+/\\d+/\\d+\\.html"
            },
            {
                :categories => ["IT"],
                :regexp     => "https?://(www\\.)?dni\\.ru/tech/\\d+/\\d+/\\d+/\\d+\\.html"
            },
            {
                :categories => ["Sport"],
                :regexp     => "https?://(www\\.)?dni\\.ru/sport/\\d+/\\d+/\\d+/\\d+\\.html"
            },
            {
                :categories => ["Culture"],
                :regexp     => "https?://(www\\.)?dni\\.ru/culture/\\d+/\\d+/\\d+/\\d+\\.html"
            },
            {
                :categories => ["Auto"],
                :regexp     => "https?://(www\\.)?dni\\.ru/auto/\\d+/\\d+/\\d+/\\d+\\.html"
            },
            {
                :categories => ["Showbiz"],
                :regexp     => "https?://(www\\.)?dni\\.ru/showbiz/\\d+/\\d+/\\d+/\\d+\\.html"
            },
            {
                :categories => ["Photos"],
                :regexp     => "https?://(www\\.)?dni\\.ru/photo/\\d+/\\d+/\\d+/\\d+.html"
            },
            {
                :categories => ["Videos"],
                :regexp     => "https?://(www\\.)?dni\\.ru/video/\\d+/\\d+/\\d+/\\d+.html"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "BBC Russian",
        :id         => "bbc-co-uk--russian",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?bbc\\.co\\.uk/russian/(russia|uk|indepth|interactivity|multimedia)/\\d+/\\d+/\\w+\\.shtml"
            },
            {
                :categories => ["Economics", "Business"],
                :regexp     => "https?://(www\\.)?bbc\\.co\\.uk/russian/business/\\d+/\\d+/\\w+\\.shtml"
            },
            {
                :categories => ["Science"],
                :regexp     => "https?://(www\\.)?bbc\\.co\\.uk/russian/science/\\d+/\\d+/\\w+\\.shtml"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?://(www\\.)?bbc\\.co\\.uk/russian/society/\\d+/\\d+/\\w+\\.shtml"
            },
            {
                :categories => ["Sport"],
                :regexp     => "https?://(www\\.)?bbc\\.co\\.uk/russian/sport/\\d+/\\d+/\\w+\\.shtml"
            },
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Известия",
        :id         => "izvestia-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?izvestia\\.ru/news/\\d+"
            }
        ]
    }
]
