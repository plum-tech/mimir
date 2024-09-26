'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.json": "7b0c3b22ac99fe2d2436c12adb4d9b1f",
"assets/assets/yellow_pages.json": "d58c88892fa69b0f73e7782bc4d53ac8",
"assets/assets/l10n/zh-Hant.yaml": "4d99e21c90f1976f6cf3e47295645001",
"assets/assets/l10n/en.yaml": "773505a42bcc47d7d7e6d0a0064e2187",
"assets/assets/l10n/zh-Hans.yaml": "d29c4f60c9f679ac1c35fc436cb531e5",
"assets/assets/icon.svg": "927ec35ec9a7673ac8246d795f73b1b3",
"assets/assets/course/sports.png": "d528811d769d719f8db43cd0a559831d",
"assets/assets/course/music.png": "af6cfda520e5c85417705e7dada5301a",
"assets/assets/course/geography.png": "66f118f392327744d364f483e59fdd14",
"assets/assets/course/curriculum.png": "6ff0a0da7acd3be3a0c7eed823fb34ab",
"assets/assets/course/circuit.png": "c79d310e89be329ba3d259d3e6c21cdb",
"assets/assets/course/management.png": "d5b2eba065dbde49cf170fd8725cab95",
"assets/assets/course/reading.png": "7e58dfbc0caf516dd8b81b40aba3b052",
"assets/assets/course/practice.png": "028512e2b76c3e5260b7c5b8a12c7ebd",
"assets/assets/course/language.png": "65b261464b967d80c6f6b4bc659aaf5f",
"assets/assets/course/political%2520.png": "3eed8d749a589227775fe28c6bfbe2b3",
"assets/assets/course/social.png": "64aff1c937d8013794bba48326dfd35f",
"assets/assets/course/control.png": "23e7e67eb510eb6a80a5b55919687f0a",
"assets/assets/course/building.png": "899b96e30e66953f4179395f1b32c491",
"assets/assets/course/physical.png": "ee1fd81f60eaeb2a26734706b313d493",
"assets/assets/course/internship.png": "b358a2fac48e94305cda4b25e7a00b6f",
"assets/assets/course/technology.png": "27440f14524c4b577c323878fe2e733d",
"assets/assets/course/biological.png": "a98b8b99874413ab73b734e8c24dc27f",
"assets/assets/course/running.png": "8e713a6af75c0fc2711662a71dbfc263",
"assets/assets/course/computer.png": "a636a8fc12e7054d33cf977c5b3c7192",
"assets/assets/course/engineering.png": "ec3cc054206a1d7c2ce6963eb7fff9f4",
"assets/assets/course/training.png": "b35ba741487216f4e12314bc967937a6",
"assets/assets/course/economic.png": "9683dd0d743841eadc644abea0091ff8",
"assets/assets/course/statistical.png": "bea4e1ff9b6aa73b0ad8fa0560f31f0b",
"assets/assets/course/experiment.png": "1e2458eec7da6a4b7e185498bf0369e2",
"assets/assets/course/art.png": "d9ad98492dacd62bc45dd9cd58e20aa1",
"assets/assets/course/electricity.png": "3201853a2fd7f9f4be1a31335f9f1dfd",
"assets/assets/course/design.png": "5a9bbb7d6ce125f12b95d9f28620c8bf",
"assets/assets/course/mechanical.png": "22e9edccb60c3a38627b0fd2192d84d8",
"assets/assets/course/principle.png": "69cda51ddb4f6bfbf278d2d34e84a06b",
"assets/assets/course/history.png": "104a6e2bfb122790264b45e5c910b88b",
"assets/assets/course/ideological.png": "6aaf2fc6660219248e8da24079fd3068",
"assets/assets/course/mathematics.png": "9b7d61e3bcdf5060b54cb44af5b822ab",
"assets/assets/course/chemical.png": "920b2208a1e55fbac7539fc1be88f0b1",
"assets/assets/course/literature.png": "af003aa88dcb927f17c9a0532183e6af",
"assets/assets/course/business.png": "e9e3cacc91f2a58b9a71038936aebca8",
"assets/assets/course/generality.png": "43c0944d86c5d0dd45df4ceda69d84f3",
"assets/assets/webview/dark.js": "498386f1bc9dc514fcff0cc36de4bded",
"assets/assets/game/wordle/cet-6.json": "bff24af0a70003608848ac40a2986b68",
"assets/assets/game/wordle/all.json": "553293c282b91d26cf102debd7a4ecb6",
"assets/assets/game/wordle/cet-4.json": "4ec8195a5da0454506ee7d15d5f2dfc0",
"assets/assets/game/wordle/toefl.json": "48cfbe773e6c2568a184f8a99e3c08ef",
"assets/assets/game/wordle/ielts.json": "9bea796af15d0d30d90628d5a05798e9",
"assets/assets/game/suika/fruit-3.png": "3da07039e4e5d5d0fc8862a9e7ee684e",
"assets/assets/game/suika/fruit-8.png": "ec2d794f9d1ee719b711f88de327aac6",
"assets/assets/game/suika/fruit-11.png": "8bb14b6266e187d780f19353b2dcbc54",
"assets/assets/game/suika/fruit-7.png": "42021dfd793428273d90aef8909bbc26",
"assets/assets/game/suika/fruit-5.png": "5be15afbbf574f8ece9b48ddd4819e7b",
"assets/assets/game/suika/fruit-10.png": "d70b47aeab87821ce5777d80e3c7f640",
"assets/assets/game/suika/fruit-2.png": "88a9d738210093ff35f5742f8dafe9dd",
"assets/assets/game/suika/fruit-4.png": "72fa0bdebe2012c3f58899e831d2a61e",
"assets/assets/game/suika/fruit-9.png": "8d60b387af630a19327eae490829b580",
"assets/assets/game/suika/fruit-1.png": "f069ea993f1ee7b023ee35ea6484f7c7",
"assets/assets/game/suika/fruit-6.png": "eff0468affb1dddf4697079be42072ad",
"assets/assets/icon.png": "2ada07dff4ab590c1b28a69a4d5a8fb2",
"assets/assets/room_list.json": "78d893e953b322b610a27f05d8cfd259",
"assets/assets/fonts/ywb_iconfont.ttf": "b18459c938a1617db73ccb9bb42f6a01",
"assets/AssetManifest.bin.json": "e3e67fb30a9e3737681633a55110448d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "4f916fbad089d56971c40f6ad9032cdc",
"assets/FontManifest.json": "f6f0fb617e585a59b149ec326e13b8a1",
"assets/NOTICES": "e586705593f375168eda43c514614cae",
"assets/fonts/MaterialIcons-Regular.otf": "aa5b7631a83ddb54405dc4db13c52db7",
"assets/packages/unicons/icons/UniconsSolid.ttf": "59478f879666fa4b425646b8a7c9c84d",
"assets/packages/unicons/icons/UniconsThinline.ttf": "d6746849cd712399a13b2b1b03d31bce",
"assets/packages/unicons/icons/UniconsLine.ttf": "2ccc0859760cea4bc6d58d76bcf6b163",
"assets/packages/simple_icons/fonts/SimpleIcons.ttf": "36006a2aee699bab11e4562e9bd81963",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "543414608f399ef14d5ca83b677be19b",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flex_color_picker/assets/opacity.png": "49c4f3bcb1b25364bb4c255edcaaf5b2",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/flutter_image_compress_web/assets/pica.min.js": "6208ed6419908c4b04382adc8a3053a2",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "ffd063c5ddbbe185f778e7e41fdceb31",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"main.dart.js": "7791f100acf2d523c7e0acc9875d42ad",
"browserconfig.xml": "0f181289d3870795841c7b87e64ef043",
"favicon-16x16.png": "008131cb7732322aa778587e69478052",
"favicon-32x32.png": "c1e55fd2b7e8bc8287e4a47ab848cdb7",
"flutter_bootstrap.js": "d2a08a23833f9daa10e66581141f4200",
"mstile-150x150.png": "d54bcd8eff1758b0b8f23358ad690db1",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"android-chrome-192x192.png": "eb2e6ac54048f188a954aa790bdb69a7",
"apple-touch-icon.png": "c2437e7f93ac971f681f841ce3ecaba0",
"android-chrome-512x512.png": "4a3ac54ecc60fb81fc681a8a6ba52130",
"index.html": "61b0f0ed1a8007a13b37623703e7ec9c",
"/": "61b0f0ed1a8007a13b37623703e7ec9c",
"favicon.ico": "ca28e54c0450a94e47743c36e81dcf08",
"version.json": "8757c84246c71a6e28bcbd2f269134c8",
"manifest.json": "5418877150506df4596162635b40271e",
"safari-pinned-tab.svg": "5bb147f89ad4b856101bfb3d126aa8da"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
