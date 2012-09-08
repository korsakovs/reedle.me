# encoding: utf-8

$SITES = [

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Lenta.Ru",
        :id         => "lenta-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?lenta\\.ru/\\w+/\\d+/\\d+/\\d+/\\w+"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Gazeta.Ru",
        :id         => "gazeta-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?gazeta\\.ru/\\w+/\\d+/\\d+/\\d+/\\d+\\.shtml"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "IT" ],
        :title      => "Habrahabr",
        :id         => "habrahabr-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?habrahabr\\.ru/post/\\d+"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "Blogs" ],
        :title      => "Livejournal.Ru",
        :id         => "livejournal-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?\\w+\\.livejournal\\.ru/\\d+\\.html"
        ]
    },

    {
        :countries  => [ "WWW" ],
        :categories => [ "Blogs" ],
        :title      => "Livejournal.Com",
        :id         => "livejournal-com",
        :regexp     => [
            "https?:\/\/(www\\.)?\\w+\\.livejournal\\.com/\\d+\\.html"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Omskpress",
        :id         => "omskpress-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?omskpress\\.ru/news/\\w+"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Город 55",
        :id         => "gorod55-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?gorod55\\.ru/news/article/show/\\?rubric=(\\d+)&id=(\\d+)"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "ОмскИнформ",
        :id         => "omskinform-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?omskinform\\.ru/main\\.php\\?id=1&nid=(\\d+)"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "НГС55",
        :id         => "ngs55-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?ngs55\\.ru/news/\\d+/view"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Инфомск",
        :id         => "infomsk-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?infomsk\\.ru/\\w+/news/\\w+"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "LifeNews",
        :id         => "lifenews-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?lifenews\\.ru/news/\\d+"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "РиаНовости",
        :id         => "ria-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?ria\\.ru/\\w+/\\d+/\\d+.html"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Newsru.com",
        :id         => "newsru-com",
        :regexp     => [
            "https?:\/\/(www\\.)?newsru\\.com/\\w+/\\w+/\\w+.html"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "Новости@Mail.Ru",
        :id         => "news-mail-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?news\\.mail\\.ru/\\w+/\\d+",
            "https?:\/\/(www\\.)?news\\.mail\\.ru/\\w+/\\w+/\\d+/\\w+/\\d+"
        ]
    },

    {
        # TODO: Echo have blogs
        :countries  => [ "RU" ],
        :categories => [ "News", "Politics" ],
        :title      => "Эхо Москвы",
        :id         => "echo.msk.ru",
        :regexp     => [
            "https?:\/\/(www\\.)?echo\\.msk\\.ru/news/\\d+-echo\\.html",
            "https?:\/\/(www\\.)?echo\\.msk\\.ru/blog/\\w+/\\d+-echo"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News" ],
        :title      => "РБК",
        :id         => "rbc-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?top\\.rbc\\.ru/\\w+/\\d+/\\d+/\\d+/\\d+\\.shtml"
        ]
    },

    {
        :countries  => [ "RU" ],
        :categories => [ "News", "Business" ],
        :title      => "РБК daily",
        :id         => "rbc-ru",
        :regexp     => [
            "https?:\/\/(www\\.)?rbcdaily\\.ru/\\d+/\\d+/\\d+/\\w+/\\d+"
        ]
    },

]
