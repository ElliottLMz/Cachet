# Cachet
A powerful Lua module for caching

# Motivation
I made Cachet as I was repeating a lot of code in systems that required caching. I built Cachet to be as robust and powerful
as possible, with the intention to be a one-fits-all solution for anything related to caching.

---------

# Installation
Cachet is very simple to install, simply copy `Cachet.lua` from the `src` folder into a newly created [ModuleScript](https://developer.roblox.com/en-us/api-reference/class/ModuleScript).

> **Advanced Users**:
> Cachet has no dependencies, so it can be easily included as a Git submodule and synched with your project via [Rojo](https://rojo.space). 

### Use outside Roblox
Cachet is <u>not</u> designed for usage outside Roblox. To utilize Cachet outside of Roblox, you will need to make some modifications.

-----------------------------------

# API Reference

In the future, Cachet will likely have a documentation website. Until that arrives, this README serves as the official documentation.

### Cachet.new
```lua
Cachet.new(defaultValues: table) -> cache
```

Creates, prepares, and returns a `cache` object.

**Parameters**
<table>
  <thead>
    <th>Name</th>
    <th>Type</th>
    <th>Required</th>
  </thead>
  <tbody>
    <td>defaultValues</td>
    <td>dictionary&lt;key:any&gt;</td>
    <td>❌</td>
  </tbody>
</table>

**Returns**: cache


### cache:retrieve
```lua
cache:retrieve(key) -> any(value), dictionary(raw)
```

Returns `key from the cache, assuming it exists. The `raw` dictionary contains the following keys:

* `guid`: the unique reference to the key
* `value`: the current value stored in the cache
- `stored`: a UNIX timestamp the value was put into the cache
- `willInvalidate`: the timestamp the GUID is expected to be invalidated. `nil` if the key is not expected to be invalidated,
this is basedc on the `invalidateAfter` property on `cache.store`.

**Parameters**
<table>
  <thead>
    <th>Name</th>
    <th>Type</th>
    <th>Required</th>
  </thead>
  <tbody>
    <td>key</td>
    <td>string</td>
    <td>✔</td>
  </tbody>
</table>

**Returns**: any(value), dictionary(raw)


### cache:store
```lua
cache:store(key, value, invalidateAfter) -> string(guid)
```

Stores `key` into the cache. If `invalidateAfter` is specified, the key will be removed from the cache after that time
assuming the key is unchanged.

**Parameters**
<table>
  <thead>
    <th>Name</th>
    <th>Type</th>
    <th>Required</th>
  </thead>
  <tbody>
    <td>key</td>
    <td>string</td>
    <td>✔</td>
  </tbody>
  <tbody>
    <td>value</td>
    <td>any</td>
    <td>✔</td>
   <tbody>
    <td>invalidateAfter</td>
    <td>number</td>
    <td>❌</td>
  </tbody>
  </tbody>
</table>

**Returns**: string(guid)



### cache:getKeyFromGUID
```lua
cache:getKeyFromGUID(guid) -> string(key) | void
```

Retrives the key based on the GUID provided. Can return `nil` if they key does not exist.

**Parameters**
<table>
  <thead>
    <th>Name</th>
    <th>Type</th>
    <th>Required</th>
  </thead>
  <tbody>
    <td>guid</td>
    <td>string</td>
    <td>✔</td>
  </tbody>
</table>

**Returns**: string(key) | void


### cache:invalidateKey
```lua
cache:invalidateKey(key) -> bool(success)
```

Invalidates the key. `success` will be `false` if the key was not in the cache.

**Parameters**
<table>
  <thead>
    <th>Name</th>
    <th>Type</th>
    <th>Required</th>
  </thead>
  <tbody>
    <td>key</td>
    <td>string</td>
    <td>✔</td>
  </tbody>
</table>

**Returns**: bool(success)



### cache:invalidateGUID
```lua
cache:invalidateGUID(guid) -> bool(success)
```

Invalidates the cache entry from GUID. `success` will be `false` if the GUID was not in the cache.

**Parameters**
<table>
  <thead>
    <th>Name</th>
    <th>Type</th>
    <th>Required</th>
  </thead>
  <tbody>
    <td>guid</td>
    <td>string</td>
    <td>✔</td>
  </tbody>
</table>

**Returns**: bool(success)


### cache:connect
```lua
cache:connect(function) -> RBXScriptConnection
```

Connects a callback to the cache's event. This event is fired with the following parameters:
* `oldValue`: This is the original value of the key. `oldValue == nil` identifies that the key was newly created.
* `value`: This is the new value of the key. `value == nil` identifies that the key was invalidated.
* `guid`: This is the new GUID for the cache entry. `guid == nil` identifies that the key was invalidated.

**Parameters**
<table>
  <thead>
    <th>Name</th>
    <th>Type</th>
    <th>Required</th>
  </thead>
  <tbody>
    <td>callback</td>
    <td>function</td>
    <td>✔</td>
  </tbody>
</table>

**Returns**: [RBXScriptConnection](https://developer.roblox.com/en-us/api-reference/datatype/RBXScriptConnection)



### cache:destroy
```lua
cache:destroy() -> void
```

Destroys the cache, removes all data, and disconnects any callbacks. Attempts to use the cache after calling `destroy` can result
in error and unintended behaviour.

**Parameters**

None

**Returns**: void

-----------------------------------------------

# Licence
Cachet is licenced under MIT so you can do pretty much whatever you'd like with it. See the [licence](https://github.com/ElliottLMz/Cachet/blob/master/LICENSE) file for more details.

------------------------------

# Contributing
 
### Pull Requests
Please feel free to contribute to the code, however please note:
* Entirely format/style changes will be denied
* Please bare backwards compatability in mind when making changes
* **Leave comments** about what your code does!!
* Changes that improve the code's performance are 100% welcome! I want Cachet to be as fast as possible.
* Please avoid implementing feature requests unless an issue has opened and there has been discussion about the feature

### Issues
If you spot something wrong, or have a feature request, <u>please open an issue</u>!! I want to make Cachet as powerful as possible,
so even if you don't use Cachet, issues are very helpful to improving it!


-------------------------

# Credits
Cachet was created by ElliottLMz.
Thanks to BenSBk for help designing the typechecker.
