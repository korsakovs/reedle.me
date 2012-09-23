# encoding: utf-8

$SITES = [

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Lenta.Ru",
        :id         => "lenta-ru",
        :urls       => [
            {
                :categories  => ["News"],
                :regexp      => "https?:\/\/(www\\.)?lenta\\.ru/\\w+/\\d+/\\d+/\\d+/\\w+"
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
    }

]
