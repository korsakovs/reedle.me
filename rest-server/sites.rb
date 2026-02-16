# encoding: utf-8

=begin
TODO: add following sites:
http://www.regnum.ru/news/polit/1811462.html
=end

$SITES = [

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Meduza",
        :id         => "meduza-io",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?://(www\\.)?meduza\\.io/news/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["News"],
                :regexp     => "https?://(www\\.)?meduza\\.io/feature/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["News", "Photos"],
                :regexp     => "https?://(www\\.)?meduza\\.io/galleries/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["News"],
                :regexp     => "https?://(www\\.)?meduza\\.io/shapito/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["News"],
                :regexp     => "https?://(www\\.)?meduza\\.io/cards/[A-Za-z0-9_-]+"
            }
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Lenta.Ru",
        :id         => "lenta-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?://(www\\.)?lenta\\.ru/news/\\d+/\\d+/\\d+/\\w+"
            },
            {
                :categories => ["Articles"],
                :regexp     => "https?://(www\\.)?lenta\\.ru/articles/\\d+/\\d+/\\d+/\\w+"
            },
            {
                :categories => ["Videos"],
                :regexp     => "https?://(www\\.)?lenta\\.ru/video/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Photos"],
                :regexp     => "https?://(www\\.)?lenta\\.ru/photo/\\d+/\\d+/\\d+/\\w+"
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
                :categories => ["Business"],
                # http://www.gazeta.ru/business/2012/10/11/4808925.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/business/\\d+/\\d+/\\d+/\\d+.shtml"
            },
            {
                :categories => ["Politics"],
                # http://www.gazeta.ru/politics/2012/10/11_a_4808845.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/politics/\\d+/\\d+/[A-Za-z0-9_-]+.shtml"
            },
            {
                :categories => ["Business"],
                # http://www.gazeta.ru/financial/2012/10/12/4809529.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/financial/\\d+/\\d+/\\d+/\\d+.shtml"
            },
            {
                :categories => ["Society"],
                # http://www.gazeta.ru/social/2012/10/12/4809525.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/social/\\d+/\\d+/\\d+/\\d+.shtml"
            },
            {
                :categories => [],
                # http://www.gazeta.ru/comments/2012/10/10_x_4807865.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/comments/\\d+/\\d+/[A-Za-z0-9_-]+.shtml"
            },
            {
                :categories => ["Culture"],
                # http://www.gazeta.ru/culture/2012/10/12/a_4809709.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/culture/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+.shtml"
            },
            {
                :categories => ["Science"],
                # http://www.gazeta.ru/science/2012/10/12_a_4809601.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/science/\\d+/\\d+/[A-Za-z0-9_-]+.shtml"
            },
            {
                :categories => ["Auto"],
                # http://www.gazeta.ru/auto/2012/10/12_a_4809933.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/auto/\\d+/\\d+/[A-Za-z0-9_-]+.shtml"
            },
            {
                :categories => ["Sport"],
                # http://www.gazeta.ru/sport/2012/10/12/a_4809885.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/sport/(news/)?\\d+/\\d+/\\d+/[A-Za-z0-9_-]+.shtml"
            },
            {
                :categories => ["Photo"],
                # http://www.gazeta.ru/auto/photo/final_mazda_sport_cup.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/\\w+/photo/[A-Za-z0-9_-]+.shtml"
            },
            {
                :categories => ["Video"],
                # http://www.gazeta.ru/social/video/ekaterina_samutsevich_vyhodit_na_svobodu.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/\\w+/video/[A-Za-z0-9_-]+.shtml"
            },
            {
                :categories => ["IT"],
                # http://www.gazeta.ru/techzone/2012/10/02_a_4796721.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/techzone/\\d+/\\d+/[A-Za-z0-9_-]+.shtml"
            },
            {
                :categories => ["Business"],
                # http://www.gazeta.ru/social/2012/10/05/4802349.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/money/\\d+/\\d+/[A-Za-z0-9_-]+.shtml"
            },
            {
                :categories => [],
                # http://www.gazeta.ru/lifestyle/travel/2012/10/01_a_4794633.shtml
                :regexp     => "https?://(www\\.)?gazeta\\.ru/lifestyle/\\w+/\\d+/\\d+/[A-Za-z0-9_-]+.shtml"
            },
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
                :regexp     => "https?://(www\\.)?habrahabr\\.ru/post/\\d+"
            },
            {
                :categories => ["IT"],
                :regexp     => "https?://(www\\.)?habrahabr\\.ru/company/\\w+/blog/\\d+"
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
                :regexp     => "https?://(www\\.)?\\w+\\.livejournal\\.ru/\\d+\\.html",
                :blog_id    => "\\w+\\.livejournal\\.ru"
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
                :regexp     => "https?://(www\\.)?\\w+\\.livejournal\\.com/\\d+\\.html",
                :blog_id    => "\\w+\\.livejournal\\.com"
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
                :regexp     => "https?://(www\\.)?omskpress\\.ru/news/\\d+/\\w+"
            }
        ]
    },

=begin
Looks like there is no more metromsk :()
    {
        :countries  => [ "RU" ],
        :categories => [ "News", "Politics" ],
        :title      => "Метромск",
        :id         => "metromsk-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?metromsk\\.com/\\w+/\\d+/\\d+/\\d+/\\w+\\.html"
            }
        ]
    },
=end

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Город 55",
        :id         => "gorod55-ru",
        :urls       => [
            {
                :categories => ["News"],
                :regexp     => "https?://(www\\.)?gorod55\\.ru/news/article/[A-Za-z0-9_-]+"
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
                :regexp     => "https?://(www\\.)?omskinform\\.ru/news/\\d+"
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
                :regexp     => "https?://(www\\.)?ngs55\\.ru/news/\\d+/view"
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
                :regexp     => "https?://(www\\.)?infomsk\\.ru/[A-Za-z0-9_-]+/news/[A-Za-z0-9_-]+"
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
                :regexp     => "https?://(www\\.)?lifenews\\.ru/news/\\d+"
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
                :regexp     => "https?://(www\\.)?ria\\.ru/\\w+/\\d+/\\d+.html"
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
                :regexp     => "https?://(www\\.)?newsru\\.com/\\w+/\\w+/\\w+.html"
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
                :regexp     => "https?://(www\\.)?news\\.mail\\.ru/\\w+/\\d+",
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
                :regexp     => "https?://(www\\.)?echo\\.msk\\.ru/news/\\d+-echo\\.html"
            },
            {
                :categories => ["Politics", "Blogs"],
                :regexp     => "https?://(www\\.)?echo\\.msk\\.ru/blog/\\w+/\\d+-echo"
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
                :categories => [],
                :regexp     => "https?://(www\\.)?top\\.rbc\\.ru/[A-Za-z0-9_-]+/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?rbc\\.ru/rbcfreenews/[A-Za-z0-9_-]+"
            },
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News", "Business" ],
        :title      => "РБК daily",
        :id         => "rbc-dayly-ru",
        :urls       => [
            {
                :categories => ["Economics"],
                :regexp     => "https?://(www\\.)?rbcdaily\\.ru/(economy|finance)/\\d+"
            },
            {
                :categories => ["Politics"],
                :regexp     => "https?://(www\\.)?rbcdaily\\.ru/politics/\\d+"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?://(www\\.)?rbcdaily\\.ru/society/\\d+"
            },
            {
                :categories => ["Auto"],
                :regexp     => "https?://(www\\.)?rbcdaily\\.ru/autonews/\\d+"
            },
            {
                :categories => ["Sport"],
                :regexp     => "https?://(www\\.)?rbcdaily\\.ru/sport/\\d+"
            },
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?rbcdaily\\.ru/(world|industry|market|media|business)/\\d+"
            },
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?rbcdaily\\.ru/addition/article/\\d+"
            },
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
                :regexp     => "https?://(www\\.)?mnenia\\.ru/rubric/politics/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Finance"],
                :regexp     => "https?://(www\\.)?mnenia\\.ru/rubric/finance/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Culture"],
                :regexp     => "https?://(www\\.)?mnenia\\.ru/rubric/culture/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["IT"],
                :regexp     => "https?://(www\\.)?mnenia\\.ru/rubric/tech/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?://(www\\.)?mnenia\\.ru/rubric/society/[A-Za-z0-9_-]+"
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
                :regexp     => "https?://(www\\.)?novayagazeta\\.ru/columns/\\d+\\.html"
            },
            {
                :categories => ["Economics"],
                :regexp     => "https?://(www\\.)?novayagazeta\\.ru/economy/\\d+\\.html"
            },
            {
                :categories => ["Politics"],
                :regexp     => "https?://(www\\.)?novayagazeta\\.ru/politics/\\d+\\.html"
            },
            {
                :categories => ["Inquests"],
                :regexp     => "https?://(www\\.)?novayagazeta\\.ru/inquests/\\d+\\.html"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?://(www\\.)?novayagazeta\\.ru/society/\\d+\\.html"
            },
            {
                :categories => ["Culture"],
                :regexp     => "https?://(www\\.)?novayagazeta\\.ru/arts/\\d+\\.html"
            },
            {
                :categories => ["Sports"],
                :regexp     => "https?://(www\\.)?novayagazeta\\.ru/sports/\\d+\\.html"
            },
            {
                :categories => ["Photos"],
                :regexp     => "https?://(www\\.)?novayagazeta\\.ru/photos/\\d+\\.html"
            },
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?novayagazeta\\.ru/comments/\\d+\\.html"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Радио Свобода",
        :id         => "svoboda-org",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?svoboda\\.org/content/article/\\d+\\.html"
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
                :regexp     => "https?://(www\\.)?sports\\.ru/tribuna/blogs/[A-Za-z0-9_-]+/\\d+\\.html"
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
                :regexp     => "https?://(www\\.)?news\\.sportbox\\.ru/Vidy_sporta/(Futbol|Hokkej|Basketbol|Avtosport|Biatlon|Volejbol|Tennis|Formula_1|Boks|plavanie)(/[A-Za-z0-9_-]+)?/spbnews_[A-Za-z0-9_-]+"
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
                :regexp     => "https?://(www\\.)?kp\\.ru/online/news/\\d+"
            },
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?kp\\.ru/daily/\\d+(\\.\\d+)?/\\d+"
            },
            {
                :categories => ["Photos"],
                :regexp     => "https?://(www\\.)?kp\\.ru/photo/(gallery|\\d+)/\\d+"
            },
            {
                :categories => ["Videos"],
                :regexp     => "https?://(www\\.)?kp\\.ru/video/\\d+"
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
                :regexp     => "https?://(www\\.)?snob\\.ru/(selected|magazine)/entry/\\d+"
            },
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?snob\\.ru/profile/\\d+/blog/\\d+"
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
                :regexp     => "https?://(www\\.)?motor\\.ru/(news|articles)/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Photos"],
                :regexp     => "https?://(www\\.)?motor\\.ru/photo/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Videos"],
                :regexp     => "https?://(www\\.)?motor\\.ru/video/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Интерфакс",
        :id         => "interfax-ru",
        :urls       => [
            {
                :categories => ["Politics"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/politics/\\d+"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/society/\\d+"
            },
            {
                :categories => ["Business"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/business/\\d+"
            },
            {
                :categories => ["Sport"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/sport/\\d+"
            },
            {
                :categories => ["Culture"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/culture/\\d+"
            },
            {
                :categories => ["Photos"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/photo/\\d+"
            },
            {
                :categories => ["Videos"],
                :regexp     => "https?://(www\\.)?interfax\\.ru/video/\\d+"
            },
            { # Will be applied if nothing was found
                :categories => [],
                :regexp     => "https?://(www\\.)?interfax\\.ru/[A-Za-z0-9_-]+/\\d+"
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
                :regexp     => "https?://(www\\.)?bbc\\.co\\.uk/russian/(russia|uk|indepth|interactivity|multimedia)/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Economics", "Business"],
                :regexp     => "https?://(www\\.)?bbc\\.co\\.uk/russian/business/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Science"],
                :regexp     => "https?://(www\\.)?bbc\\.co\\.uk/russian/science/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?://(www\\.)?bbc\\.co\\.uk/russian/society/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Sport"],
                :regexp     => "https?://(www\\.)?bbc\\.co\\.uk/russian/sport/\\d+/\\d+/[A-Za-z0-9_-]+"
            },
            { # Will be applied if nothing was found
                :categories => [],
                :regexp     => "https?://(www\\.)?bbc\\.co\\.uk/russian/[A-Za-z0-9_-]+/\\d+/\\d+/[A-Za-z0-9_-]+"
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
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Slon",
        :id         => "slon-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?slon\\.ru/(russia|world|future)/[A-Za-z0-9_-]+\\.xhtml"
            },
            {
                :categories => ["Economics"],
                :regexp     => "https?://(www\\.)?slon\\.ru/economics/[A-Za-z0-9_-]+\\.xhtml"
            },
            {
                :categories => ["Business"],
                :regexp     => "https?://(www\\.)?slon\\.ru/(business|money)/[A-Za-z0-9_-]+\\.xhtml"
            }
#            {
#                :categories => ["Photos"],
#                :regexp     => "https?://(www\\.)?slon\\.ru/[A-Za-z0-9_-]+/photo/[A-Za-z0-9_-]+/[A-Za-z0-9_-]+\\.xhtml"
#            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Быстрый Slon",
        :id         => "slon-ru-fast",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?slon\\.ru/fast/(russia|world|future)/[A-Za-z0-9_-]+\\.xhtml"
            },
            {
                :categories => ["Economics"],
                :regexp     => "https?://(www\\.)?slon\\.ru/fast/economics/[A-Za-z0-9_-]+\\.xhtml"
            },
            {
                :categories => ["Business"],
                :regexp     => "https?://(www\\.)?slon\\.ru/fast/(business|money)/[A-Za-z0-9_-]+\\.xhtml"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "ИТАР-ТАСС",
        :id         => "itar-tass-ru",
        :urls       => [
            {
                :categories => ["Politics"],
                :regexp     => "https?://(www\\.)?iter-tass\\.com/politika/\\d+"
            },
            {
                :categories => ["Society", "Politics"],
                :regexp     => "https?://(www\\.)?itar-tass\\.com/mezhdunarodnaya-panorama/\\d+"
            },
            {
                :categories => ["Science"],
                :regexp     => "https?://(www\\.)?itar-tass\\.com/nauka/\\d+"
            },
            {
                :categories => ["Economics"],
                :regexp     => "https?://(www\\.)?itar-tass\\.com/ekonomika/\\d+"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?://(www\\.)?itar-tass\\.com/obschestvo/\\d+"
            },
            {
                :categories => ["Sport"],
                :regexp     => "https?://(www\\.)?itar-tass\\.com/sport/\\d+"
            },
            {
                :categories => ["Culture"],
                :regexp     => "https?://(www\\.)?itar-tass\\.com/kultura/\\d+"
            },
            { # Will be applied if nothing was found
                :categories => [],
                :regexp     => "https?://(www\\.)?itar-tass\\.com/[A-Za-z0-9_-]+/\\d+"
            },
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Metro",
        :id         => "metronews-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?metronews\\.ru/novosti/[A-Za-z0-9_-]+/[A-Za-z0-9_-]+/"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Российская Газета",
        :id         => "rg-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?rg\\.ru/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+\\.html"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "НТВ",
        :id         => "ntv-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?ntv\\.ru/novosti/\\d+/"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Аргументы и Факты",
        :id         => "aif-ru",
        :urls       => [
            {
                :categories => ["Photos"],
                :regexp     => "https?://(www\\.)?aif\\.ru/[A-Za-z0-9_-]+/gallery/\\d+"
            },
            {
                :categories => ["Politics"],
                :regexp     => "https?://(www\\.)?aif\\.ru/politics/[A-Za-z0-9_-]+/\\d+"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?://(www\\.)?aif\\.ru/society/[A-Za-z0-9_-]+/\\d+"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?://(www\\.)?aif\\.ru/society/\\d+"
            },
            {
                :categories => ["Incidents"],
                :regexp     => "https?://(www\\.)?aif\\.ru/incidents/[A-Za-z0-9_-]+/\\d+"
            },
            {
                :categories => ["Business", "Economics"],
                :regexp     => "https?://(www\\.)?aif\\.ru/money/[A-Za-z0-9_-]+/\\d+"
            },
            {
                :categories => ["Culture"],
                :regexp     => "https?://(www\\.)?aif\\.ru/culture/[A-Za-z0-9_-]+/\\d+"
            },
            {
                :categories => ["Sport"],
                :regexp     => "https?://(www\\.)?aif\\.ru/sport/[A-Za-z0-9_-]+/\\d+"
            },
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?aif\\.ru/(food|dacha|health|realty|interview|travel)/[A-Za-z0-9_-]+/\\d+"
            },
            {
                :categories => ["Auto"],
                :regexp     => "https?://(www\\.)?aif\\.ru/auto/[A-Za-z0-9_-]+/\\d+"
            },
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Ведомости",
        :id         => "vedomosti-ru",
        :urls       => [
            {
                :categories => ["Politics"],
                :regexp     => "https?://(www\\.)?vedomosti\\.ru/politics/news/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Economics", "Business"],
                :regexp     => "https?://(www\\.)?vedomosti\\.ru/finance/news/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Business"],
                :regexp     => "https?://(www\\.)?vedomosti\\.ru/companies/news/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["IT"],
                :regexp     => "https?://(www\\.)?vedomosti\\.ru/tech/news/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Auto"],
                :regexp     => "https?://(www\\.)?vedomosti\\.ru/auto/news/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => ["Sport"],
                :regexp     => "https?://(www\\.)?vedomosti\\.ru/sport/news/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?vedomosti\\.ru/(realty|career|lifestyle)/news/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?vedomosti\\.ru/[A-Za-z0-9_-]+/news/\\d+/[A-Za-z0-9_-]+"
            },
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?vedomosti\\.ru/newspaper/article/\\d+/[A-Za-z0-9_-]+"
            },
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "RT на русском",
        :id         => "russian-rt-com",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?russian\\.rt\\.com/article/\\d+"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Коммерсант.ru",
        :id         => "kommersant-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?kommersant\\.ru/(doc|news)/\\d+"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Московский Комсомолец",
        :id         => "mk-ru",
        :urls       => [
            {
                :categories => ["Politics"],
                :regexp     => "https?://(www\\.)?mk\\.ru/politics/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+\\.html"
            },
            {
                :categories => ["Economics"],
                :regexp     => "https?://(www\\.)?mk\\.ru/economics/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+\\.html"
            },
            {
                :categories => ["Incidents"],
                :regexp     => "https?://(www\\.)?mk\\.ru/incident/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+\\.html"
            },
            {
                :categories => ["Society"],
                :regexp     => "https?://(www\\.)?mk\\.ru/social/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+\\.html"
            },
            {
                :categories => ["Sport"],
                :regexp     => "https?://(www\\.)?mk\\.ru/sport/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+\\.html"
            },
            {
                :categories => ["Culture"],
                :regexp     => "https?://(www\\.)?mk\\.ru/culture/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+\\.html"
            },
            {
                :categories => ["Science"],
                :regexp     => "https?://(www\\.)?mk\\.ru/science/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+\\.html"
            },
            { # Will be applied if nothing was found
                :categories => [],
                :regexp     => "https?://(www\\.)?mk\\.ru/[A-Za-z0-9_-]/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+\\.html"
            },
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "dp.ru",
        :id         => "dp-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?dp\\.ru/a/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+/"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News"],
        :title      => "Пятый Канал",
        :id         => "5-tv-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?5-tv\\.ru/news/\\d+/"
            }
        ]
    },

    {
        :countries  => ["RU"],
        :categories => ["News", "IT", "Business"],
        :title      => "Roem.Ru",
        :id         => "roem-ru",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?roem.ru/\\d+/\\d+/\\d+/\\d+/[A-Za-z0-9_-]+/"
            }
        ]
    },

    {
        :countries  => ["WWW"],
        :categories => ["YouTube"],
        :title      => "YouTube",
        :id         => "youtube-com",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?youtube\\.com/watch\\?((NR|feature)=\\w+&)*v=[A-Za-z0-9_-]{11}"
            }
        ]
    },

    {
        :countries  => ["WWW"],
        :categories => ["News"],
        :title      => "Twitter",
        :id         => "twitter-com",
        :urls       => [
            {
                :categories => [],
                :regexp     => "https?://(www\\.)?(twitter|x)\\.com/[A-Za-z0-9_]+/status/\\d+"
            }
        ]
    }
]
